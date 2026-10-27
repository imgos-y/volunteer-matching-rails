class EventRegistrationsController < ApplicationController
  before_action :require_volunteer, only: %i[create cancel]
  before_action :require_organizer, only: %i[confirm_attendance mark_no_show]

  def create
    event = Event.find(params[:event_id])
    registration = event.event_registrations.find_or_initialize_by(volunteer: current_volunteer)
    if registration.status == "registered"
      return redirect_to events_path, alert: "You are already registered for this event."
    end

    registration.status = "registered"
    registration.registered_at = Time.current

    # etkinlik satırını kilitleyerek aynı anda gelen kayıtların kapasiteyi aşmasını engeller
    saved = event.with_lock { registration.save }

    if saved
      redirect_to events_path, notice: "You have successfully joined the event."
    else
      redirect_to events_path, alert: registration.errors.full_messages.to_sentence
    end
  end

  def cancel
    registration = current_volunteer.event_registrations.includes(:event)
                                    .find_by(event_id: params[:event_id], status: "registered")

    if registration.nil?
      redirect_to events_path, alert: "You have no active registration for this event."
    elsif registration.event.past?
      redirect_to my_events_path, alert: "This event has already taken place, so the registration can no longer be cancelled."
    elsif registration.update(status: "cancelled")
      redirect_to events_path, notice: "Registration cancelled."
    else
      redirect_to events_path, alert: registration.errors.full_messages.to_sentence
    end
  end

  def confirm_attendance
    update_attendance("attended", notice: "Attendance confirmed.") do |volunteer|
      volunteer.award_points(10)
    end
  end

  def mark_no_show
    update_attendance("no_show", notice: "Marked as no-show.") do |volunteer|
      volunteer.deduct_points(5)
    end
  end

  private

  # kaydı kilitleyip durumunu ve puanı tek transaction içinde günceller;
  # sadece "registered" durumundaki kayıt değiştirilebildiği için aynı istek tekrar puan vermez
  def update_attendance(new_status, notice:)
    registration = current_organizer.events.find(params[:event_id]).event_registrations.find(params[:id])

    updated = registration.with_lock do
      next false unless registration.status == "registered"

      registration.update!(status: new_status)
      yield registration.volunteer
      true
    end

    if updated
      redirect_to organizer_dashboard_path, notice: notice
    else
      redirect_to organizer_dashboard_path, alert: "This registration has already been processed."
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to organizer_dashboard_path, alert:
      e.record.errors.full_messages.to_sentence
  end
end
