require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "delegated_type exposes the profile" do
    user = users(:emir)

    assert user.volunteer?
    assert_not user.organizer?
    assert_equal volunteers(:emir), user.volunteer
  end
end
