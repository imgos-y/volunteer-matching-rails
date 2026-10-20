require "test_helper"

class BadgeTest < ActiveSupport::TestCase
  test "fixtures are valid" do
    assert badges(:bronze).valid?
    assert badges(:silver).valid?
    assert badges(:gold).valid?
  end

  test "required_points must be greater than zero" do
    badge = badges(:bronze)

    badge.required_points = 0

    assert_not badge.valid?
    assert_includes badge.errors[:required_points], "must be greater than 0"
  end
end
