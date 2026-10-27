require "test_helper"

class EventRegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "a volunteer can join an event" do
    sign_in_as(users(:imge))
    assert_difference "EventRegistration.count", 1 do
      post event_event_registration_path(events(:workshop))
    end

    assert_redirected_to events_path
  end

  test "confirming attendance twice awards points only once" do
    sign_in_as(users(:tema))
    event = events(:cleanup)
    travel_to 2.weeks.from_now do
      registration = event_registrations(:emir_cleanup)

      patch confirm_attendance_path(event, registration)
      patch confirm_attendance_path(event, registration)

      assert_equal 10, volunteers(:emir).reload.points
      end
  end

  test "a signed out user cannot join an event " do
    assert_no_difference "EventRegistration.count" do
      post event_event_registration_path(events(:workshop))
    end
    assert_redirected_to root_path
  end

  test "an organizer cannot confirm attendance for another organizer's event" do
    sign_in_as(users(:losev))
    registration = event_registrations(:emir_cleanup)

    patch confirm_attendance_path(events(:cleanup), registration)

    assert_response :not_found
    assert_equal "registered", registration.reload.status
  end

  test "attendance cannot be confirmed before the event" do
    sign_in_as(users(:tema))
    registration = event_registrations(:emir_cleanup)

    patch confirm_attendance_path(events(:cleanup), registration)

    assert_redirected_to organizer_dashboard_path
    assert_equal "Attendance can only be confirmed after the event", flash[:alert]
    assert_equal "registered", registration.reload.status
  end
end
