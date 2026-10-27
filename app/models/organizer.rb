class Organizer < ApplicationRecord
  include Userable

  has_many :events, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  normalizes :name, with: ->(e) { e.squish }

  validates :name, presence: true
end
