class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.references :organizer, null: false, foreign_key: true
      # organizere ait foreign key olarak alıyor
      t.string :name
      t.text :description
      t.datetime :event_date
      t.integer :capacity
      t.string :skill_needed
      t.string :interest_needed

      t.timestamps
    end
  end
end
