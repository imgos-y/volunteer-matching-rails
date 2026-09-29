class CreateBadges < ActiveRecord::Migration[8.1]
  def change
    create_table :badges do |t|
      t.string :name
      t.integer :required_points
      t.integer :required_event

      t.timestamps
    end
  end
end
