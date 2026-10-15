class RemoveDeviseColumnsFromVolunteersAndOrganizers < ActiveRecord::Migration[8.1]
  def change
    %i[volunteers organizers].each do |table|
      remove_index table, :email, unique: true
      remove_index table, :reset_password_token, unique: true

      remove_column table, :email, :string, default: "", null: false
      remove_column table, :encrypted_password, :string, default: "", null: false
      remove_column table, :reset_password_token, :string
      remove_column table, :reset_password_sent_at, :datetime
      remove_column table, :remember_created_at, :datetime
    end
  end
end
