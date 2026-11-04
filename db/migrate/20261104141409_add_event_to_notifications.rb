class AddEventToNotifications < ActiveRecord::Migration[8.1]
  def change
    add_reference :notifications, :event, null: true, foreign_key: true
  end
end
