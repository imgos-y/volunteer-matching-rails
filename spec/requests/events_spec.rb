require 'rails_helper'

RSpec.describe "Events", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:organizer) do
    Organizer.create!(email: "org@example.com", password: "123456", name: "John")
  end

  let(:volunteer) do
    Volunteer.create!(email: "vol@example.com", password: "123456", name: "Sarah", surname: "Volunteer", skill: "Cooking", interest: "Health")
  end

  let(:event_attributes) do
    {
      name: "Community Cleanup",
      description: "Cleaning the park",
      event_date: 1.week.from_now,
      capacity: 5,
      skill_needed: "Cooking",
      interest_needed: "Health"
    }
  end

  let(:event) { organizer.events.create!(event_attributes) }

  describe "GET /events" do
    before { sign_in volunteer }

    it "shows Join Event for an event the volunteer has not joined" do
      event
      get events_path
      expect(response.body).to include("Join Event")
    end

    it "shows Attended instead of Join Event after attendance is confirmed" do
      event.event_registrations.create!(volunteer: volunteer, status: "registered", registered_at: Time.current).update!(status: "attended")

      get events_path

      expect(response.body).to include("Attended")
      expect(response.body).not_to include("Join Event")
    end

    it "shows Marked as No-Show instead of Join Event for a no-show" do
      event.event_registrations.create!(volunteer: volunteer, status: "registered", registered_at: Time.current).update!(status: "no_show")

      get events_path

      expect(response.body).to include("Marked as No-Show")
      expect(response.body).not_to include("Join Event")
    end
  end
end
