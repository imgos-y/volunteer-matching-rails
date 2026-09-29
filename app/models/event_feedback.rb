class EventFeedback < ApplicationRecord
  belongs_to :event
  belongs_to :volunteer

  validates :rating, presence: true, inclusion: { in: 1..5 }

  after_create_commit :notify_organizer

  private

  def notify_organizer
    Notification.create!(
      recipient: event.organizer,
      message: "#{volunteer.name} #{volunteer.surname} left feedback for '#{event.name}'",
      notification_type: "feedback"
    )
  end
end