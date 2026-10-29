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

  test "squishes name and surname" do
    volunteer = Volunteer.new(name: "  Ayşe   Nur ", surname: " Yılmaz  ")
    assert_equal "Ayşe Nur", volunteer.name
    assert_equal "Yılmaz", volunteer.surname
  end

  test "next_badge skips a badge the volunteer has just reached" do
    volunteer = volunteers(:emir)
    volunteer.points = 50

    assert_equal badges(:gold), volunteer.next_badge
    assert_equal 50, volunteer.points_to_next_badge
  end

  test "earning a badge notifies the volunteer" do
    volunteer = volunteers(:emir)
    assert_difference -> { volunteer.notifications.count }, 1 do
      volunteer.award_points(10)
    end
  end

  test "points without a new badge do not notify" do
    volunteer = volunteers(:emir)
    assert_no_difference -> { volunteer.notifications.count } do
      volunteer.award_points(5)
    end
  end
end
