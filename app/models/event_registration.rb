class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer

  STATUSES = %w[registered attended cancelled no_show].freeze
  ACTIVE_STATUSES = %w[registered attended].freeze

  # attended ve no_show son durumlardır; iptal edilen kayıt tekrar açılabilir
  ALLOWED_TRANSITIONS = {
    "registered" => %w[attended no_show cancelled],
    "cancelled" => %w[registered]
  }.freeze

  validates :status, inclusion: { in: STATUSES }
  validate :valid_status_transition, on: :update
  # hem yeni kayıtta hem de iptal edilmiş kaydın tekrar açılmasında çalışır
  validate :event_open_for_registration, if: :becoming_active?
  validate :not_already_actively_registered, if: :becoming_active?
  validate :capacity_not_exceeded, if: :becoming_active?
  validate :event_has_taken_place, if: :becoming_final?

  # callbacks
  after_create_commit :notify_organizer_of_registration
  after_create_commit :notify_organizer_if_full
  after_update_commit :notify_on_status_change, if: :saved_change_to_status?
  after_create_commit :notify_volunteer_of_registration

  scope :due_for_reminder, -> {
    joins(:event)
      .where(status: "registered", reminder_sent_at: nil)
      .where(events: { cancelled: false, event_date: Time.current..24.hours.from_now })
  }

  def send_reminder!
    transaction do
      Notification.create!(
        recipient: volunteer,
        message: "Reminder: '#{event.name}' starts on #{event.event_date.strftime('%d.%m.%Y %H:%M')}",
        notification_type: "event_reminder"
      )
      update!(reminder_sent_at: Time.current)
    end
  end

  private

  def becoming_active?
    status == "registered" && (new_record? || will_save_change_to_status?)
  end

  def becoming_final?
    will_save_change_to_status? && status.in?(%w[attended no_show])
  end

  def valid_status_transition
    return unless will_save_change_to_status?

    from, to = status_in_database, status
    return if ALLOWED_TRANSITIONS.fetch(from, []).include?(to)

    errors.add(:status, "cannot change from #{from} to #{to}")
  end

  def event_open_for_registration
    return unless event

    if event.cancelled?
      errors.add(:base, "Event has been cancelled")
    elsif event.event_date.present? && event.event_date < Time.current
      errors.add(:base, "Event has already taken place")
    end
  end

  def event_has_taken_place
    return unless event
    errors.add(:base, "Attendance can only be confirmed after the event") unless event.past?
  end

  def capacity_not_exceeded
    return unless event

    # kaydın kendisi sayıya dahil edilmez (tekrar kayıt durumunda)
    taken = event.event_registrations.where(status: ACTIVE_STATUSES).where.not(id: id).count
    errors.add(:base, "Event is full") if taken >= event.capacity
  end

  def not_already_actively_registered
    return unless event && volunteer

    existing = event.event_registrations.where(volunteer: volunteer, status: ACTIVE_STATUSES)
    existing = existing.where.not(id: id) if persisted?

    errors.add(:base, "Already registered for this event") if existing.exists?
  end

  def notify_organizer_of_registration
    Notification.create!(
      recipient: event.organizer,
      message: "#{volunteer.name} #{volunteer.surname} registered for '#{event.name}'",
      notification_type: "registration"
    )
  end

  def notify_volunteer_of_registration
    Notification.create!(
      recipient: volunteer,
      message: "You registered for '#{event.name}'",
      notification_type: "registration_confirmed"
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
    when "registered"
      notify_organizer_of_registration
      notify_organizer_if_full
      notify_volunteer_of_registration
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
