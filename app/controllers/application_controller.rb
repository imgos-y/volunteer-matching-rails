class ApplicationController < ActionController::Base
  include Authentication
  helper_method :unread_notifications_count

  private

  def unread_notifications_count
    recipient = current_user&.userable
    return 0 unless recipient

    recipient.notifications.unread.count
  end
end
