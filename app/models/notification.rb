class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  # polymorphic birden fazla referansı destekler
  # recipient_id → hangi kaydın ID'si olduğu (örneğin volunteer'ın id'si)
  # recipient_type → hangi tabloya ait olduğu ("Volunteer" veya "Organizer" string'i olarak)


  scope :unread, -> { where(read: false) }

  scope :recent_first, -> { order(created_at: :desc) }
  # en yeni bildirim en üstte

  after_commit :broadcast_unread_count, on: [ :create, :update ],
               if: :unread_count_changed?

  after_create_commit :broadcast_to_list
  private

  def broadcast_to_list
    broadcast_prepend_to recipient, :notifications,
                         target: "notifications",
                         partial: "notifications/notification",
                         locals: { notification: self }
  end

  def unread_count_changed?
    previously_new_record? || saved_change_to_read?
  end
  def broadcast_unread_count
    broadcast_update_to recipient, :notifications,
                        target: "unread_notifications_count",
                        partial: "notifications/unread_count",
                        locals: { count: recipient.notifications.unread.count }
  end
end
