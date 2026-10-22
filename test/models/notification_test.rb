require "test_helper"
require "turbo/broadcastable/test_helper"

class NotificationTest < ActiveSupport::TestCase
  include Turbo::Broadcastable::TestHelper
  test "a new notification updates the count and is prepended to the list" do
    organizer = organizers(:tema)

    streams = capture_turbo_stream_broadcasts [ organizer, :notifications ] do
      organizer.notifications.create!(message: "New registration")
    end

    assert_equal %w[ prepend update ], streams.map { |stream| stream["action"] }.sort
  end

  test "marking a notification as read broadcasts the unread count" do
    notification = organizers(:tema).notifications.create!(message: "New registration")

    assert_turbo_stream_broadcasts [ organizers(:tema), :notifications ], count: 1 do
      notification.update!(read: true)
    end
  end
end
