require "test_helper"

class Volunteers::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "signing up creates a user and a volunteer profile" do
    assert_difference [ "User.count", "Volunteer.count" ], 1 do
      post volunteers_registration_path, params: {
        volunteer: {
          name: "Zeynep", surname: "Kaya", skill: "Teaching", interest: "Education",
          user_attributes: { email_address: "zeynep@example.com", password: "secret123", password_confirmation: "secret123" }
        }
      }
    end

    assert_redirected_to events_path
    assert cookies[:session_id]

    user = User.find_by(email_address: "zeynep@example.com")
    assert_equal "Zeynep", user.volunteer.name
  end
end
