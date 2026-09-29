require 'rails_helper'

RSpec.describe EventRegistration, type: :model do
  let(:organizer) do
    Organizer.create!(email: "org@example.com", password: "123456", name: "John", surname: "Manager")
  end

  let(:volunteer) do
    Volunteer.create!(email: "vol@example.com", password: "123456", name: "Sarah", surname: "Volunteer", skill: "Cooking", interest: "Health")
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

  it "allows a volunteer to register for an event" do
    registration = event.event_registrations.new(volunteer: volunteer, status: "registered", registered_at: Time.current)
    expect(registration).to be_valid
  end

  it "prevents registering for a full event" do
    other_volunteer = Volunteer.create!(email: "other@example.com", password: "123456", name: "Ali", surname: "Yılmaz", skill: "Cooking", interest: "Health")
    event.event_registrations.create!(volunteer: other_volunteer, status: "registered", registered_at: Time.current)

    registration = event.event_registrations.new(volunteer: volunteer, status: "registered", registered_at: Time.current)
    expect(registration).not_to be_valid
  end

  it "prevents duplicate active registration for the same event" do
    event.update!(capacity: 5)
    event.event_registrations.create!(volunteer: volunteer, status: "registered", registered_at: Time.current)

    duplicate = event.event_registrations.new(volunteer: volunteer, status: "registered", registered_at: Time.current)
    expect(duplicate).not_to be_valid
  end

  it "allows re-registering after a previous cancellation" do
    event.update!(capacity: 5)
    first = event.event_registrations.create!(volunteer: volunteer, status: "registered", registered_at: Time.current)
    first.update!(status: "cancelled")

    second = event.event_registrations.new(volunteer: volunteer, status: "registered", registered_at: Time.current)
    expect(second).to be_valid
  end
end