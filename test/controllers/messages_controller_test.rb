require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  test "a participant can open the event chat" do
    sign_in_as(users(:emir))

    get event_messages_path(events(:cleanup))

    assert_response :success
  end

  test "a non-participant is turned away from the event chat" do
    sign_in_as(users(:imge))

    get event_messages_path(events(:cleanup))

    assert_redirected_to events_path
    assert_equal "You don't have access to this chat.", flash[:alert]
  end

  test "a participant can post a message" do
    sign_in_as(users(:emir))

    assert_difference "Message.count", 1 do
      post event_messages_path(events(:cleanup)), params: { message: { body: "See you there!" } }
    end

    assert_redirected_to event_messages_path(events(:cleanup))
    assert_equal users(:emir), Message.last.user
  end

  test "a blank message is not posted" do
    sign_in_as(users(:emir))

    assert_no_difference "Message.count" do
      post event_messages_path(events(:cleanup)), params: { message: { body: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "a non-participant cannot post a message" do
    sign_in_as(users(:imge))

    assert_no_difference "Message.count" do
      post event_messages_path(events(:cleanup)), params: { message: { body: "Hi" } }
    end

    assert_redirected_to events_path
  end

  test "the organizer can delete any message in the chat" do
    sign_in_as(users(:tema))

    assert_difference "Message.count", -1 do
      delete event_message_path(events(:cleanup), messages(:emir_hello))
    end

    assert_redirected_to event_messages_path(events(:cleanup))
  end

  test "a participant cannot delete someone else's message" do
    message = Message.create!(event: events(:cleanup), user: users(:tema), body: "Welcome!")
    sign_in_as(users(:emir))

    assert_no_difference "Message.count" do
      delete event_message_path(events(:cleanup), message)
    end

    assert_redirected_to event_messages_path(events(:cleanup))
  end
end
