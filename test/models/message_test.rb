require "test_helper"

class MessageTest < ActiveSupport::TestCase
  test "body is required" do
    message = Message.new(event: events(:cleanup), user: users(:emir),
                          body: "")
    assert_not message.valid?
    assert_includes message.errors[:body], "can't be blank"
  end

  # boundary testing
  test "body is limited to 1000 characters" do
    message = Message.new(event: events(:cleanup), user: users(:emir),
                          body: "a" * 1001)
    assert_not message.valid?

    message.body = "a" * 1000
    assert message.valid?
  end

  test "cannot post to a cancelled event" do
    message = Message.new(event: events(:cancelled_meetup), user: users(:tema), body: "Hello")
    assert_not message.valid?
    assert_includes message.errors[:event], "is cancelled"
  end

  test "only chat participants can post" do
    message = Message.new(event: events(:cleanup), user: users(:imge), body: "Hello")

    assert_not message.valid?
    assert_includes message.errors[:user], "is not a participant of this chat"
  end

  test "the author and the event organizer can delete a message" do
    message = messages(:emir_hello)

    assert message.deletable_by?(users(:emir))       # yazar
    assert message.deletable_by?(users(:tema))       # organizatör
    assert_not message.deletable_by?(users(:imge))   # başka biri
    assert_not message.deletable_by?(users(:losev))  # başka bir organizatör
  end

  test "a new message notifies the other participants once until they read it" do
    assert_difference -> { organizers(:tema).notifications.count }, 1 do
      assert_no_difference -> { volunteers(:emir).notifications.count } do
        Message.create!(event: events(:cleanup), user: users(:emir), body: "First")
      end
    end

    assert_no_difference -> { organizers(:tema).notifications.count } do
      Message.create!(event: events(:cleanup), user: users(:emir), body: "Second")
    end
  end

  test "a chat notification comes again after the previous one is read" do
    Message.create!(event: events(:cleanup), user: users(:emir), body: "First")
    organizers(:tema).notifications.update_all(read: true)

    assert_difference -> { organizers(:tema).notifications.count }, 1 do
      Message.create!(event: events(:cleanup), user: users(:emir), body: "Second")
    end
  end
end
