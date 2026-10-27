class Event < ApplicationRecord
  belongs_to :organizer

  has_many :event_registrations, dependent: :destroy
  has_many :volunteers, through: :event_registrations
  has_many :event_feedbacks, dependent: :destroy
  # many to many ilişkisi

  validates :name, :description, :event_date, :capacity, :skill_needed, :interest_needed, presence: true
  validates :skill_needed, inclusion: { in: Volunteer::SKILLS }, allow_blank: true
  validates :interest_needed, inclusion: { in: Volunteer::INTERESTS }, allow_blank: true
  # bu alanların boş bırakılamayacağını uygulama seviyesinde zorunlu kıldık
  validates :capacity, numericality: { greater_than: 0 }, allow_blank: true
  # kapasite 0 olamaz
  validate :event_date_not_in_past, if: :will_save_change_to_event_date?
  # sadece tarih değişirken kontrol edilir, tarihi geçmiş etkinlik yine iptal edilebilir

  scope :upcoming, -> { where(cancelled: false).where("event_date >= ?", Time.current) }

  def active_registration_count
    event_registrations.where(status: %w[registered attended]).count
  end

  def full?
    active_registration_count >= capacity
  end
  def past?
    event_date < Time.current
  end

  def skill_match?(volunteer)
    skill_needed == volunteer.skill
  end

  def interest_match?(volunteer)
    interest_needed == volunteer.interest
  end

  def match_score_for(volunteer)
    return 2 if skill_match?(volunteer) && interest_match?(volunteer)
    return 1 if skill_match?(volunteer) || interest_match?(volunteer)

    0
  end

  def self.ordered_for_volunteer(volunteer, relation = upcoming)
    relation.sort_by { |event| -event.match_score_for(volunteer) }
  end

  def cancel!
    return if cancelled?

    transaction do
      update!(cancelled: true)

      event_registrations.where(status: "registered").includes(:volunteer).each do |registration|
        Notification.create!(
          recipient: registration.volunteer,
          message: "'#{name}' Has been cancelled by the organizer",
          notification_type: "event_cancelled"
        )
      end

      event_registrations.where(status: "registered").update_all(status: "cancelled", updated_at: Time.current)
    end
  end
  private

  def event_date_not_in_past
    return if event_date.blank?

    errors.add(:event_date, "can't be in the past") if event_date < Time.current
  end
end
