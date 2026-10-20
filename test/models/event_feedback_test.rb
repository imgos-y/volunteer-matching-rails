require "test_helper"

class EventFeedbackTest < ActiveSupport::TestCase
  test "rating must be between 1 and 5" do
    feedback = EventFeedback.new(event: events(:past_cleanup), volunteer: volunteers(:emir), rating: 6)

    assert_not feedback.valid?
    assert_includes feedback.errors[:rating], "is not included in the list"
  end

  test "a new feedback notifies the organizer" do
    assert_difference -> { organizers(:tema).notifications.count }, 1 do
      EventFeedback.create!(event: events(:past_cleanup), volunteer: volunteers(:emir), rating: 5)
    end
  end
end
