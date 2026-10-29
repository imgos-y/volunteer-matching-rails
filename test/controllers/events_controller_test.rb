require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "anyone can see upcoming events without signing in" do
    get events_path

    assert_response :success
    assert_includes response.body, events(:cleanup).name
  end

  test "an organizer can create an event" do
    sign_in_as(users(:tema))
    assert_difference "Event.count", 1 do
      post events_path,
           params: { event: { name: "Tree Planting", description: "Plant trees.",
                              event_date: 1.week.from_now, capacity: 10, skill_needed: "Driving",
                              interest_needed: "Environment" } }
    end

    assert_redirected_to organizer_dashboard_path
  end

  test "a volunteer cannot create an event" do
    sign_in_as(users(:emir))
    assert_no_difference "Event.count" do
      post events_path,
           params: { event: { name: "Tree Planting", description: "Plant trees.",
                              event_date: 1.week.from_now, capacity: 10, skill_needed: "Driving",
                              interest_needed: "Environment" } }
    end
    assert_redirected_to root_path
    assert_equal "This page is only for organizers.", flash[:alert]
  end

  test "an organizer can cancel an event with a reason" do
    sign_in_as(users(:tema))

    patch cancel_event_path(events(:cleanup)),
          params: { event: { cancellation_reason: "Storm warning" } }
    assert_redirected_to organizer_dashboard_path
    assert events(:cleanup).reload.cancelled?
    assert_equal "Storm warning", events(:cleanup).reload.cancellation_reason
  end

  test "cancelling without a reason shows an alert" do
    sign_in_as(users(:tema))

    patch cancel_event_path(events(:cleanup)),
          params: { event: { cancellation_reason: "" } }

    assert_redirected_to organizer_dashboard_path
    assert_equal "Cancellation reason can't be blank", flash[:alert]
    assert_not events(:cleanup).reload.cancelled?
  end

  test "an organizer cannot update another organizer's event" do
    sign_in_as(users(:losev))

    patch event_path(events(:cleanup)), params: { event: { name: "Hacked event" } }

    assert_response :not_found
    assert_equal "Beach Cleanup", events(:cleanup).reload.name
  end
end
