class MoveDeviseAccountsToUsers < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
INSERT INTO users (email_address, password_digest, userable_type, userable_id, created_at, updated_at)
SELECT LOWER(TRIM(email)), encrypted_password, 'Volunteer', id, created_at, updated_at
FROM volunteers
    SQL

    execute <<~SQL
INSERT INTO users (email_address, password_digest, userable_type, userable_id, created_at, updated_at)
SELECT LOWER(TRIM(email)), encrypted_password, 'Organizer', id, created_at, updated_at
FROM organizers
    SQL
  end

  def down
    execute "DELETE FROM users"
  end
end
