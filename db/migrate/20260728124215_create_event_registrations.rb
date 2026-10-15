class CreateEventRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :event_registrations do |t|
      t.references :event, null: false, foreign_key: true
      t.references :volunteer, null: false, foreign_key: true
      t.string :status
      t.datetime :registered_at

      t.timestamps
    end

    add_index :event_registrations, [ :event_id, :volunteer_id ], unique: true
    # unique index
  end
end
