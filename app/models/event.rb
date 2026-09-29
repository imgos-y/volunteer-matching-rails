class Event < ApplicationRecord
  belongs_to :organizer

  has_many :event_registrations, dependent: :destroy
  has_many :volunteers, through: :event_registrations
  has_many :event_feedbacks, dependent: :destroy
  # many to many ilişkisi

  validates :name, :description, :event_date, :capacity, presence: true
  validates :skill_needed, inclusion: { in: Volunteer::SKILLS }
  validates :interest_needed, inclusion: { in: Volunteer::INTERESTS }
  # bu alanların boş bırakılamayacağını uygulama seviyesinde zorunlu kıldık
  validates :capacity, numericality: { greater_than: 0 }
  # kapasite 0 olamaz

  scope :upcoming, -> { where(cancelled: false).where("event_date >= ?", Time.current) }

  def active_registration_count
    event_registrations.where(status: %w[registered attended]).count
  end

  def full?
    active_registration_count >= capacity
  end

  def match_score_for(volunteer)
    skill_match = skill_needed == volunteer.skill
    interest_match = interest_needed == volunteer.interest
    return 2 if skill_match && interest_match
    return 1 if skill_match || interest_match

    0
  end

  def self.ordered_for_volunteer(volunteer)
    upcoming.sort_by { |event| -event.match_score_for(volunteer) }
  end

  def cancel!
    update!(cancelled: true)
    event_registrations.where(status: %w[registered attended]).each do |registration|
      Notification.create!(
        recipient: registration.volunteer,
        message: "'#{name}' has been cancelled by the organizer",
        notification_type: "event_cancelled"
      )
    end
    end
end