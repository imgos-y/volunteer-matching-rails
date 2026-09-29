class NotificationsController < ApplicationController
  before_action :authenticate_user_from_either!

  def index
    @notifications = current_recipient.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notification = current_recipient.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notifications_path
  end

  private

  def authenticate_user_from_either!
    return if volunteer_signed_in? || organizer_signed_in?

    redirect_to root_path, alert: "You need to sign in first."
  end

  def current_recipient
    current_volunteer || current_organizer
  end
end