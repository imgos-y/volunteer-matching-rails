class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  delegated_type :userable, types: %w[ Volunteer Organizer ], dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true, uniqueness: true
end
