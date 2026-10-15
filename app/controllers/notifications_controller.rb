class NotificationsController < ApplicationController
  def index
    @notifications = current_recipient.notifications.order(created_at: :desc)
  end

  def mark_as_read
    notification = current_recipient.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notifications_path
  end

  private



  def current_recipient
    current_user.userable
  end
end
