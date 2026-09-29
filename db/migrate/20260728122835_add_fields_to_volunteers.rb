class AddFieldsToVolunteers < ActiveRecord::Migration[8.1]
  def change
    add_column :volunteers, :name, :string
    add_column :volunteers, :surname, :string
    add_column :volunteers, :skill, :string
    add_column :volunteers, :interest, :string
  end
end
