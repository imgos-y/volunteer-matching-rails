class EventFeedbacksController < ApplicationController
  before_action :authenticate_volunteer!

  def create
    registration = current_volunteer.event_registrations.find_by!(event_id: params[:event_id], status: "attended")
    feedback = registration.event.event_feedbacks.new(feedback_params.merge(volunteer: current_volunteer))

    if feedback.save
      redirect_to my_events_path, notice: "Thank you for your feedback."
    else
      redirect_to my_events_path, alert: feedback.errors.full_messages.to_sentence
    end
  end

  private

  def feedback_params
    params.require(:event_feedback).permit(:rating, :comment)
  end
end