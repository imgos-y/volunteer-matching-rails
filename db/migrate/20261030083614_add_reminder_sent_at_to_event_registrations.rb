class AddReminderSentAtToEventRegistrations < ActiveRecord::Migration[8.1]
  def change
    add_column :event_registrations, :reminder_sent_at, :datetime
  end
end
