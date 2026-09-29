class EventRegistrationsController < ApplicationController
  before_action :authenticate_volunteer!, only: %i[create cancel]
  before_action :authenticate_organizer!, only: %i[confirm_attendance mark_no_show]

  def create
    event = Event.find(params[:event_id])
    registration = event.event_registrations.find_or_initialize_by(volunteer: current_volunteer)
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
    registration = current_volunteer.event_registrations.find_by(event_id: params[:event_id], status: "registered")

    if registration&.update(status: "cancelled")
      redirect_to events_path, notice: "Registration cancelled."
    else
      redirect_to events_path, alert: "You have no active registration for this event."
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
  end
end
