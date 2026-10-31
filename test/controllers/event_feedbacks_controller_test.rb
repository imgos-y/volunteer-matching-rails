require "test_helper"

class EventFeedbacksControllerTest < ActionDispatch::IntegrationTest
  test "a volunteer can give feedback" do
    sign_in_as(users(:emir))
    assert_difference "EventFeedback.count", 1 do
      post event_event_feedbacks_path(events(:past_cleanup)),
           params: { event_feedback:
                       { rating: 4,
                         comment: "test" } }
    end

    assert_redirected_to my_events_path
    assert_equal 4, EventFeedback.last.rating
  end
end
