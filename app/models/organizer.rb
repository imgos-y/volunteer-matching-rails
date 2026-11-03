class Organizer < ApplicationRecord
  include Userable

  has_many :events, dependent: :destroy
  has_many :event_registrations, through: :events
  has_many :event_feedbacks, through: :events
  has_many :notifications, as: :recipient, dependent: :destroy

  normalizes :name, with: ->(e) { e.squish }

  validates :name, presence: true

  def attendance_rate
    counts = event_registrations.group(:status).count
    attended = counts.fetch("attended", 0)
    checked = attended + counts.fetch("no_show", 0)
    return if checked.zero?

    (attended.fdiv(checked) * 100).round
  end

  def average_rating
    event_feedbacks.average(:rating)
  end
end
