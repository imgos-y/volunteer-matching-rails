class OrganizersController < ApplicationController
  before_action :authenticate_organizer!

  def profile
    @organizer = current_organizer
  end

  def dashboard
    @events = current_organizer.events.order(event_date: :asc)
  end

  def feedbacks
    @feedbacks = EventFeedback.joins(:event).where(events: { organizer_id: current_organizer.id }).includes(:event, :volunteer).order(created_at: :desc)
  end
end