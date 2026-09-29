class Organizer < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :events, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  validates :name, presence: true


end
