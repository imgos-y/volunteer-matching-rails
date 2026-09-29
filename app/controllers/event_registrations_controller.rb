class EventRegistrationsController < ApplicationController
  before_action :authenticate_volunteer!, only: %i[create cancel]
  before_action :authenticate_organizer!, only: %i[confirm_attendance]

  def create
    event = Event.find(params[:event_id])
    registration = event.event_registrations.find_or_initialize_by(volunteer: current_volunteer)
    registration.status = "registered"
    registration.registered_at = Time.current

    if registration.save
      redirect_to events_path, notice: "You have successfully joined the event."
    else
      redirect_to events_path, alert: registration.errors.full_messages.to_sentence
    end
  end

  def cancel
    registration = current_volunteer.event_registrations.find_by!(event_id: params[:event_id])
    registration.update(status: "cancelled")
    redirect_to events_path, notice: "Registration cancelled."
  end

  def confirm_attendance
    registration = current_organizer.events.find(params[:event_id]).event_registrations.find(params[:id])
    registration.update(status: "attended")
    registration.volunteer.award_points(10)
    redirect_to organizer_dashboard_path, notice: "Attendance confirmed."
  end

  def mark_no_show
    registration = current_organizer.events.find(params[:event_id]).event_registrations.find(params[:id])
    registration.update(status: "no_show")
    registration.volunteer.deduct_points(5)
    redirect_to organizer_dashboard_path, notice: "Marked as no-show."
  end
end