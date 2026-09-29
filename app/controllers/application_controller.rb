class ApplicationController < ActionController::Base
  helper_method :unread_notifications_count

  private

  def unread_notifications_count
    recipient = current_volunteer || current_organizer
    return 0 unless recipient

    recipient.notifications.unread.count
  end
end