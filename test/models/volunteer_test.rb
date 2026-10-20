require "test_helper"

class VolunteerTest < ActiveSupport::TestCase
  test "award_points adds points" do
    volunteer = volunteers(:emir)

    volunteer.award_points(10)

    assert_equal 10, volunteer.reload.points
  end

  test "award_points gives the first badge the volunteer qualifies for" do
    volunteer = volunteers(:emir)

    assert_nil volunteer.badge

    volunteer.award_points(10)

    assert_equal badges(:bronze), volunteer.reload.badge
  end

  test "award_points gives the highest badge the volunteer qualifies for" do
    volunteer = volunteers(:emir)

    volunteer.award_points(60)

    assert_equal badges(:silver), volunteer.reload.badge
  end

  test "deduct_points never goes below zero" do
    volunteer = volunteers(:emir)

    volunteer.deduct_points(5)

    assert_equal 0, volunteer.reload.points
  end

  test "fixture is valid" do
    assert volunteers(:emir).valid?
  end
end
