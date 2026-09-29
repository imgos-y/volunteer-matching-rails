require 'rails_helper'

RSpec.describe Notification, type: :model do

  let(:organizer) do
    Organizer.create!(email: "org@example.com", password: "123456", name: "John", surname: "Manager")
  end

  it "default read to false" do
    notification = Notification.create!(recipient: organizer, message: "Test message")
    expect(notification.read).to eq(false)
  end

  describe ".unread" do
    it "only returns notifications that have not been read" do
      read_notification = Notification.create!(recipient: organizer, message: "Read one", read: true)
      unread_notification = Notification.create!(recipient: organizer, message: "Unread one", read: false)

      result = Notification.unread

      expect(result).to include(unread_notification)
      expect(result).not_to include(read_notification)
    end
  end

end
