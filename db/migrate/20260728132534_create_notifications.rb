class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.string :message
      t.string :notification_type
      t.boolean :read, default: false

      t.timestamps
    end
  end
end
