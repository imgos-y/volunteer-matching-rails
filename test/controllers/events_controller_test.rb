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
end
