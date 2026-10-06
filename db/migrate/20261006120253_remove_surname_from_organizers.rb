class RemoveSurnameFromOrganizers < ActiveRecord::Migration[8.1]
  def change
    remove_column :organizers, :surname, :string
  end
end
