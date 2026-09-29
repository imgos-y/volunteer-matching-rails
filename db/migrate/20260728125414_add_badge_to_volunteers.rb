class AddBadgeToVolunteers < ActiveRecord::Migration[8.1]
  def change
    add_reference :volunteers, :badge, null: true, foreign_key: true
    # volunteer badgesiz var olabilir
  end
end
