require 'rails_helper'

RSpec.describe Badge, type: :model do
  let(:valid_badge_attributes) do
    { name: "Bronze" , required_points: 10 }
  end

  it " is valid attributes" do
    badge = Badge.new(valid_badge_attributes)
    expect(badge).to be_valid
  end

  it " is not valid without name" do
    badge = Badge.new(valid_badge_attributes.merge(name: nil))
    expect(badge).not_to be_valid
  end
end
