class BadgesController < ApplicationController
  before_action :require_organizer

  def index
    @badges = Badge.order(required_points: :asc)
  end

  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)

    if @badge.save
      redirect_to badges_path, notice: "Badge created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def badge_params
    params.require(:badge).permit(:name, :required_points, :required_event)
  end
end
