require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:organizer) do
    Organizer.create!(email: "org@example.com", password: "123456", name: "John")
  end

  let(:valid_event_attributes) do
    {
      name: "Community Cleanup",
      description: "Cleaning the park",
      event_date: 1.week.from_now,
      capacity: 5,
      skill_needed: "Cooking",
      interest_needed: "Health"
    }
  end

  let(:volunteer) do
    Volunteer.create!(email: "vol@example.com", password: "123456", name: "Sarah",
                      surname: "Volunteer", skill: "Cooking", interest: "Health")
  end


  it "allows a Organizer can create  an event with valid attributes" do
    event = organizer.events.new(valid_event_attributes)
    expect(event).to be_valid
  end

  it "prevents creating event capacity equals to zero " do
    event = organizer.events.new(valid_event_attributes.merge(capacity: 0))
    expect(event).not_to be_valid
  end

  it "prevent creating an event with negative capacity " do
    event = organizer.events.new(valid_event_attributes.merge(capacity: -1))
    expect(event).not_to be_valid
  end

  it "prevents creating an event with a past date" do
    event = organizer.events.new(valid_event_attributes.merge(event_date: 1.day.ago))
    expect(event).not_to be_valid
    expect(event.errors[:event_date]).to include("can't be in the past")
  end

  it "still allows cancelling an event whose date has passed" do
    event = organizer.events.create!(valid_event_attributes)
    event.update_column(:event_date, 1.day.ago)

    expect { event.cancel! }.not_to raise_error
    expect(event.reload.cancelled).to be true
  end

  it "requires a skill and an interest" do
    event = organizer.events.new(valid_event_attributes.merge(skill_needed: "", interest_needed: ""))
    expect(event).not_to be_valid
    expect(event.errors.full_messages).to include("Skill needed can't be blank", "Interest needed can't be blank")
  end

end
