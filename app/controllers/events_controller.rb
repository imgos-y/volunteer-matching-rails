class EventsController < ApplicationController
  allow_unauthenticated_access only: :index
  before_action :require_organizer, only: %i[new create edit update cancel]
  before_action :set_editable_event, only: %i[edit update]

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

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to organizer_dashboard_path, notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel
    event = current_organizer.events.find(params[:id])
    event.cancel!(cancellation_reason)
    redirect_to organizer_dashboard_path, notice: "Event cancelled."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to organizer_dashboard_path, alert: e.record.errors.full_messages.to_sentence
  end

  private

  def set_editable_event
    @event = current_organizer.events.find(params[:id])
    redirect_to organizer_dashboard_path, alert: "This event can no longer be edited." unless @event.editable?
  end

  def parse_date(value)
    Date.iso8601(value) if value.present?
  rescue ArgumentError
    nil
  end

  def event_params
    params.require(:event).permit(:name, :description, :event_date, :capacity, :skill_needed, :interest_needed)
  end

  def cancellation_reason
    params.expect(event: [ :cancellation_reason ])[:cancellation_reason]
  end
end
