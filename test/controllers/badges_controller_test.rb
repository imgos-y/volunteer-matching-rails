require "test_helper"
class BadgesControllerTest < ActionDispatch::IntegrationTest
  test "an organizer can create a badge" do
    sign_in_as(users(:tema))
    assert_difference "Badge.count", 1 do
      post badges_path,
           params: { badge: { name: "Platinum",
                              required_points: 70 } }
    end
    assert_redirected_to badges_path
  end
end
