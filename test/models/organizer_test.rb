require "test_helper"

class OrganizerTest < ActiveSupport::TestCase
  test "squishes name" do
    organizer = Organizer.new(name: "  World   Animal    Protection ")
    assert_equal "World Animal Protection", organizer.name
  end

  test "attendance_rate is attended over attended plus no-show" do
    assert_equal 50, organizers(:tema).attendance_rate
  end

  test "attendance_rate is nil when no attendance has been checked" do
    assert_nil organizers(:losev).attendance_rate
  end

  test "average_rating averages feedback across the organizer's events" do
    EventFeedback.create!(event: events(:past_cleanup), volunteer: volunteers(:emir), rating: 4)
    EventFeedback.create!(event: events(:past_cleanup), volunteer: volunteers(:imge), rating: 2)

    assert_equal 3, organizers(:tema).average_rating
  end
end
