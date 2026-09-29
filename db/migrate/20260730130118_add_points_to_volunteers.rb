class AddPointsToVolunteers < ActiveRecord::Migration[8.1]
  def change
    add_column :volunteers, :points, :integer, default: 0
  end
end
