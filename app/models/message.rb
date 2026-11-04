class Message < ApplicationRecord
  belongs_to :event
  belongs_to :user

  normalizes :body, with: ->(body) { body.strip }

  validates :body, presence: true, length: { maximum: 1000 }
  validate :event_not_cancelled, on: :create
  validate :author_is_participant, on: :create

  after_create_commit :notify_participants
  after_create_commit  -> { broadcast_refresh_to event, :messages }
  after_destroy_commit -> { broadcast_refresh_to event, :messages }

  def deletable_by?(user)
    user == self.user || user.userable == event.organizer
  end

  private

  def notify_participants
    recipients = [ event.organizer ] + event.active_registrations.includes(:volunteer).map(&:volunteer)

    recipients.each do |recipient|
      next if recipient == user.userable
      next if recipient.notifications.unread.exists?(notification_type: "chat", event: event)

      Notification.create!(recipient: recipient, event: event, notification_type: "chat",
                           message: "New messages in the '#{event.name}' chat")
    end
  end

  def event_not_cancelled
    return if event.nil?

    errors.add(:event, "is cancelled") if event.cancelled?
  end

  def author_is_participant
    return if user.nil? || event.nil?

    errors.add(:user, "is not a participant of this chat") unless event.chat_participant?(user)
  end
end
