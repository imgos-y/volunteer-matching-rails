require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:organizer) do
    Organizer.create!(email: "org@example.com", password: "123456", name: "John", surname: "Manager")
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

end
