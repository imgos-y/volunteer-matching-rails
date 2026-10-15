class EventsController < ApplicationController
  allow_unauthenticated_access only: :index
  before_action :require_organizer, only: %i[new create cancel]

  def index
    @from = parse_date(params[:from])
    @to = parse_date(params[:to])

    events = Event.upcoming
    events = events.where("event_date >= ?", @from.beginning_of_day) if @from
    events = events.where("event_date <= ?", @to.end_of_day) if @to

    @events = current_volunteer ? Event.ordered_for_volunteer(current_volunteer, events) : events.order(:event_date)
    # etkinlik id => kayıt durumu; butonu duruma göre seçmek için
    @registration_statuses = current_volunteer ? current_volunteer.event_registrations.pluck(:event_id, :status).to_h : {}
  end

  def new
    @event = current_organizer.events.new
  end

  def create
    @event = current_organizer.events.new(event_params)

    if @event.save
      redirect_to organizer_dashboard_path, notice: "Event created successfully."
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

  def parse_date(value)
    Date.iso8601(value) if value.present?
  rescue ArgumentError
    nil
  end

  def event_params
    params.require(:event).permit(:name, :description, :event_date, :capacity, :skill_needed, :interest_needed)
  end
end
