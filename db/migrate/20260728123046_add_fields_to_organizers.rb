class AddFieldsToOrganizers < ActiveRecord::Migration[8.1]
  def change
    add_column :organizers, :name, :string
    add_column :organizers, :surname, :string
  end
end
