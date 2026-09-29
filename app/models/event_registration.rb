class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer

  STATUSES = %w[registered attended cancelled no_show].freeze

  validates :status, inclusion: { in: STATUSES }
  validate :not_already_actively_registered, on: :create
  validate :capacity_not_exceeded, on: :create

  after_create_commit :notify_organizer_of_registration
  after_create_commit :notify_organizer_if_full
  after_update_commit :notify_on_status_change, if: :saved_change_to_status?

  private

  def capacity_not_exceeded
    return unless event

    errors.add(:base, "event is full") if event.full?
  end



  def not_already_actively_registered
    return unless event && volunteer

    existing = event.event_registrations.where(volunteer: volunteer, status: %w[registered attended])
    existing = existing.where.not(id: id) if persisted?

    errors.add(:base, "already registered for this event") if existing.exists?
  end

  def notify_organizer_of_registration
    Notification.create!(
      recipient: event.organizer,
      message: "#{volunteer.name} #{volunteer.surname} registered for '#{event.name}'",
      notification_type: "registration"
    )
  end

  def notify_organizer_if_full
    return unless event.full?

    Notification.create!(
      recipient: event.organizer,
      message: "'#{event.name}' has reached full capacity",
      notification_type: "capacity_full"
    )
  end

  def notify_on_status_change
    case status
    when "cancelled"
      Notification.create!(
        recipient: event.organizer,
        message: "#{volunteer.name} #{volunteer.surname} cancelled '#{event.name}'",
        notification_type: "cancellation"
      )
    when "attended"
      Notification.create!(
        recipient: volunteer,
        message: "Your attendance for '#{event.name}' has been confirmed",
        notification_type: "attendance_confirmed"
      )
    when "no_show"
      Notification.create!(
        recipient: volunteer,
        message: "You were marked as no-show for '#{event.name}'",
        notification_type: "no_show"
      )
    end
  end
end