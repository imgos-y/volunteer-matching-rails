require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "destroy signs the user out" do
    sign_in_as(users(:emir))

    assert_difference "Session.count", -1 do
      delete session_path
    end
    assert_redirected_to root_path
    assert_empty cookies[:session_id]
  end
end
