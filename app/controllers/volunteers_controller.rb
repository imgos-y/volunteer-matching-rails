class VolunteersController < ApplicationController
  before_action :require_volunteer

  def profile
    @volunteer = current_volunteer
  end

  def my_events
    @registrations = current_volunteer.event_registrations.where(status: %w[registered attended]).includes(:event)
  end

  def points
    @volunteer = current_volunteer
  end
end
