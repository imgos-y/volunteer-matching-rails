class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  #polymorphic birden fazla referansı destekler
  # recipient_id → hangi kaydın ID'si olduğu (örneğin volunteer'ın id'si)
  # recipient_type → hangi tabloya ait olduğu ("Volunteer" veya "Organizer" string'i olarak)


  scope :unread, -> { where(read: false) }

  scope :recent_first, -> { order(created_at: :desc) }
  # en yeni bildirim en üstte

end
