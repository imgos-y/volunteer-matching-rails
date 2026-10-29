require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "match_score_for counts matching skill and interest" do
    volunteer = volunteers(:emir)

    assert_equal 2, events(:cleanup).match_score_for(volunteer)
    assert_equal 1, events(:workshop).match_score_for(volunteer)
    assert_equal 0, events(:concert).match_score_for(volunteer)
  end

  test "skill_match? is true when the skill matches" do
    volunteer = volunteers(:emir)

    assert events(:cleanup).skill_match?(volunteer)
    assert_not events(:workshop).skill_match?(volunteer)
  end

  test "interest_match? is true when the interest matches" do
    volunteer = volunteers(:emir)

    assert events(:workshop).interest_match?(volunteer)
    assert_not events(:concert).interest_match?(volunteer)
  end

  test "ordered_for_volunteer puts the best matches first" do
    volunteer = volunteers(:emir)

    result = Event.ordered_for_volunteer(volunteer)

    assert_equal [ events(:cleanup), events(:workshop), events(:concert) ], result
  end

  test "upcoming excludes past and cancelled events" do
    upcoming = Event.upcoming

    assert_includes upcoming, events(:cleanup)
    assert_not_includes upcoming, events(:past_cleanup)
    assert_not_includes upcoming, events(:cancelled_meetup)
  end

  test "cannot be created with a date in the past" do
    event = events(:cleanup)
    event.event_date = 1.day.ago

    assert_not event.valid?
    assert_includes event.errors[:event_date], "can't be in the past"
  end

  test "a past event can still be updated" do
    event = events(:past_cleanup)
    event.cancelled = true
    event.cancellation_reason = "Venue unavailable"

    assert event.valid?
  end

  test "full? becomes true when active registrations reach capacity" do
    event = events(:cleanup)
    assert_not event.full?

    event.event_registrations.create!(volunteer: volunteers(:imge), status: "registered")
    assert event.full?
  end

  test "cancel" do
    event = events(:cleanup)
    registration = event_registrations(:emir_cleanup)

    assert_difference -> { volunteers(:emir).notifications.count }, 1 do
      event.cancel!("Storm warning")
    end
    assert_equal "Storm warning", event.reload.cancellation_reason
    assert_includes volunteers(:emir).notifications.last.message, "Storm warning"

    assert event.reload.cancelled?
    assert_equal "cancelled", registration.reload.status
  end

  test "cancel requires a reason" do
    event = events(:cleanup)

    assert_raises(ActiveRecord::RecordInvalid) do
      event.cancel!("")
    end
    assert_not event.reload.cancelled?
  end

  test "capacity cannot drop below active registrations" do
    event = events(:cleanup)
    EventRegistration.create!(event: event, volunteer: volunteers(:imge), status: "registered")
    event.capacity = 1

    assert_not event.valid?
    assert_includes event.errors[:capacity], "can't be lower than the number of registered volunteers"

    event.capacity = 2
    assert event.valid?
  end
end
