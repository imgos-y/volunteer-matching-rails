class EventsController < ApplicationController
  before_action :authenticate_organizer!, only: %i[new create cancel]

  def index
    @events = volunteer_signed_in? ? Event.ordered_for_volunteer(current_volunteer) : Event.upcoming
    @registered_event_ids = volunteer_signed_in? ? current_volunteer.event_registrations.where(status: "registered").pluck(:event_id) : []
  end

  def new
    @event = current_organizer.events.new
  end

  def create
    @event = current_organizer.events.new(event_params)

    if @event.save
      redirect_to events_path, notice: "Event created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def cancel
    event = current_organizer.events.find(params[:id])
    event.cancel!
    redirect_to organizer_dashboard_path, notice: "Event cancelled."
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :event_date, :capacity, :skill_needed, :interest_needed)
  end
end