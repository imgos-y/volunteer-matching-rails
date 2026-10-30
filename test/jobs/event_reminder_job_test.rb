require "test_helper"

class EventReminderJobTest < ActiveJob::TestCase
  test "reminds registered volunteers once when the event is within a day" do
    registration = event_registrations(:emir_cleanup)
    travel_to events(:cleanup).event_date - 12.hours do
      assert_difference -> { volunteers(:emir).notifications.count }, 1 do
        EventReminderJob.perform_now
      end
      assert_not_nil registration.reload.reminder_sent_at
      # ikinci çalıştırma idempotency testi
      assert_no_difference -> { volunteers(:emir).notifications.count } do
        EventReminderJob.perform_now
      end
    end
  end

  test "does not remind for events more than a day away" do
    assert_no_difference -> { Notification.count } do
      EventReminderJob.perform_now
    end
  end
end
