require "test_helper"

class OrganizerTest < ActiveSupport::TestCase
  test "squishes name" do
    organizer = Organizer.new(name: "  World   Animal    Protection ")
    assert_equal "World Animal Protection", organizer.name
  end
end
