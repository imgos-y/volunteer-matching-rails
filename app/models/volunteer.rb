class Volunteer < ApplicationRecord
  SKILLS = [
    "Cooking", "First Aid", "Teaching", "Driving", "Photography",
    "Organization", "Music", "Sports", "Technical Support", "Communication"
  ].freeze

  INTERESTS = [
    "Environment", "Animal Care", "Education", "Aid", "Community Service",
    "Sports", "Health", "Technology", "Culture", "Arts"
  ].freeze

  include Userable

  belongs_to :badge, optional: true

  has_many :event_registrations, dependent: :destroy
  has_many :events, through: :event_registrations
  has_many :event_feedbacks, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy

  after_update_commit :notify_badge_earned, if: :saved_change_to_badge_id?

  normalizes :name, :surname, with: ->(e) { e.squish }

  validates :name, :surname, presence: true
  validates :skill, inclusion: { in: SKILLS }
  validates :interest, inclusion: { in: INTERESTS }

  def award_points(amount)
    increment!(:points, amount)
    check_and_assign_badge
  end

  def deduct_points(amount)
    new_points = [ points - amount, 0 ].max
    update!(points: new_points)
  end

  def next_badge
    Badge.where("required_points > ?", points).order(:required_points).first
  end

  def points_to_next_badge
    return unless next_badge

    next_badge.required_points - points
  end

  private

  def check_and_assign_badge
    eligible = Badge.where("required_points <= ?", points).order(required_points: :desc).first
    update(badge: eligible) if eligible && eligible != badge
  end

  def notify_badge_earned
    Notification.create!(
      recipient: self,
      message: "You earned the '#{badge.name}' badge!",
      notification_type: "badge_earned"
    )
  end
end
