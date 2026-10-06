require 'rails_helper'

RSpec.describe "EventRegistrations", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:organizer) do
    Organizer.create!(email: "org@example.com", password: "123456", name: "John", surname: "Manager")
  end

  let(:event) do
    organizer.events.create!(
      name: "Community Cleanup",
      description: "Cleaning the park",
      event_date: 1.week.from_now,
      capacity: 1,
      skill_needed: "Cooking",
      interest_needed: "Health"
    )
  end

  def create_volunteer(email)
    Volunteer.create!(email: email, password: "123456", name: "Vol", surname: "Unteer", skill: "Cooking", interest: "Health")
  end

  let(:volunteer) { create_volunteer("vol@example.com") }

  describe "POST /events/:event_id/event_registration" do
    it "does not let a volunteer re-register into a full event after cancelling" do
      sign_in volunteer
      post event_event_registration_path(event)
      delete cancel_event_registration_path(event_id: event.id)

      sign_in create_volunteer("other@example.com")
      post event_event_registration_path(event)

      sign_in volunteer
      post event_event_registration_path(event)

      expect(flash[:alert]).to eq("Event is full")
      expect(event.active_registration_count).to eq(1)
    end

    it "tells a volunteer who is already registered instead of reporting success" do
      sign_in volunteer
      post event_event_registration_path(event)
      registered_at = event.event_registrations.last.registered_at

      post event_event_registration_path(event)

      expect(flash[:alert]).to eq("You are already registered for this event.")
      expect(event.event_registrations.last.registered_at).to eq(registered_at)
    end

    it "does not let a volunteer join a cancelled event" do
      event.update!(cancelled: true)
      sign_in volunteer
      post event_event_registration_path(event)

      expect(flash[:alert]).to eq("Event has been cancelled")
      expect(event.event_registrations.count).to eq(0)
    end
  end

  describe "PATCH confirm_attendance" do
    it "awards points only once per registration" do
      registration = event.event_registrations.create!(volunteer: volunteer, status: "registered", registered_at: Time.current)
      sign_in organizer

      2.times { patch confirm_attendance_path(event_id: event.id, id: registration.id) }

      expect(volunteer.reload.points).to eq(10)
      expect(flash[:alert]).to eq("This registration has already been processed.")
    end
  end

  describe "PATCH mark_no_show" do
    let!(:registration) do
      event.event_registrations.create!(volunteer: volunteer, status: "registered", registered_at: Time.current)
    end

    it "redirects an anonymous user to sign in" do
      patch mark_no_show_path(event_id: event.id, id: registration.id)
      expect(response).to redirect_to(new_organizer_session_path)
    end

    it "does not let a volunteer mark a no-show" do
      sign_in volunteer
      patch mark_no_show_path(event_id: event.id, id: registration.id)

      expect(response).to redirect_to(new_organizer_session_path)
      expect(registration.reload.status).to eq("registered")
    end

    it "cannot turn an attended registration into a no-show" do
      sign_in organizer
      patch confirm_attendance_path(event_id: event.id, id: registration.id)
      patch mark_no_show_path(event_id: event.id, id: registration.id)

      expect(registration.reload.status).to eq("attended")
      expect(volunteer.reload.points).to eq(10)
    end
  end
end
