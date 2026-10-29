require "test_helper"

class EventRegistrationTest < ActiveSupport::TestCase
  test "cannot register for a cancelled event" do
    registration = EventRegistration.new(event: events(:cancelled_meetup), volunteer: volunteers(:imge), status: "registered")

    assert_not registration.valid?
    assert_includes registration.errors[:base], "Event has been cancelled"
  end

  test "cannot register for a past event" do
    registration = EventRegistration.new(event: events(:past_cleanup), volunteer: volunteers(:imge), status: "registered")

    assert_not registration.valid?
    assert_includes registration.errors[:base], "Event has already taken place"
  end

  test "cannot register for a full event" do
    event = events(:cleanup)
    event.update!(capacity: 1)

    registration = EventRegistration.new(event: event, volunteer: volunteers(:imge), status: "registered")

    assert_not registration.valid?
    assert_includes registration.errors[:base], "Event is full"
  end

  test "cannot register twice for the same event" do
    registration = EventRegistration.new(event: events(:cleanup), volunteer: volunteers(:emir), status: "registered")

    assert_not registration.valid?
    assert_includes registration.errors[:base], "Already registered for this event"
  end

  test "an attended registration cannot become a no-show" do
    registration = event_registrations(:emir_cleanup)
    travel_to 2.weeks.from_now do
      registration.update!(status: "attended")

      registration.status = "no_show"

      assert_not registration.valid?
      assert_includes registration.errors[:status], "cannot change from attended to no_show"
      end
  end

  test "a cancelled registration can be registered again" do
    registration = event_registrations(:emir_cleanup)
    registration.update!(status: "cancelled")

    registration.status = "registered"

    assert registration.valid?
  end

  test "a new registration notifies the organizer" do
    assert_difference -> { organizers(:tema).notifications.count }, 1 do
      EventRegistration.create!(event: events(:workshop), volunteer: volunteers(:imge), status: "registered")
    end
  end

  test "a new registration notifies the volunteer" do
    assert_difference -> { volunteers(:imge).notifications.count }, 1 do
      EventRegistration.create!(event: events(:workshop), volunteer: volunteers(:imge), status: "registered")
    end
  end

  test "attendance cannot be confirmed before the event" do
    registration = event_registrations(:emir_cleanup)
    registration.status = "attended"
    assert_not registration.valid?
    assert_includes registration.errors[:base], "Attendance can only be confirmed after the event"
  end

  test "attendance can be confirmed after the event" do
    registration = event_registrations(:emir_cleanup)
    travel_to 2.weeks.from_now do
      registration.status = "attended"
      assert registration.valid?
    end
  end
end
