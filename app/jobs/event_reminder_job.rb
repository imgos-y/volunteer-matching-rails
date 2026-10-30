class EventReminderJob < ApplicationJob
  queue_as :default

  def perform
    EventRegistration.due_for_reminder.includes(:event, :volunteer).find_each(&:send_reminder!)
  end
end
