require 'rails_helper'

RSpec.describe Volunteer, type: :model do
  def valid_volunteer_attributes
    {
      email: "test@example.com",
      password: "123456",
      name: "Sümbül",
      surname: "Yüksel",
      skill: "Cooking",
      interest: "Health"
    }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      volunteer = Volunteer.new(valid_volunteer_attributes)
      expect(volunteer).to be_valid
    end

    it "is invalid without a name" do
      volunteer = Volunteer.new(valid_volunteer_attributes.merge(name: nil))
      expect(volunteer).not_to be_valid
    end

    it "is invalid with a skill outside the allowed list" do
      volunteer = Volunteer.new(valid_volunteer_attributes.merge(skill: "Not A Real Skill"))
      expect(volunteer).not_to be_valid
    end

    it "does not allow duplicate email registration" do
      Volunteer.create!(valid_volunteer_attributes)
      duplicate = Volunteer.new(valid_volunteer_attributes)
      expect(duplicate).not_to be_valid
    end
  end

  describe "#award_points" do
    it "increases the volunteer's points" do
      volunteer = Volunteer.create!(valid_volunteer_attributes)
      volunteer.award_points(10)
      expect(volunteer.points).to eq(10)
    end
  end

  describe "#deduct_points" do
    it "does not let points go below zero" do
      volunteer = Volunteer.create!(valid_volunteer_attributes)
      volunteer.deduct_points(5)
      expect(volunteer.points).to eq(0)
    end
  end


  describe "authentication" do
    it " if password is incorrect" do
      volunteer = Volunteer.create!(valid_volunteer_attributes)
      expect(volunteer.valid_password?("147258")).to be false
    end

    it "if password is correct" do
      volunteer = Volunteer.create!(valid_volunteer_attributes)
      expect(volunteer.valid_password?("123456")).to be true
    end
  end
end
