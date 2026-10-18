require "test_helper"

class Volunteers::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new renders the sign in form" do
    get new_volunteers_session_path

    assert_response :success
  end

  test "create with valid credentials signs the volunteer in" do
    post volunteers_session_path, params: { email_address: users(:emir).email_address, password: "password" }

    assert_redirected_to root_url
    assert cookies[:session_id]
  end

  test "create with wrong password does not sign the volunteer in" do
    post volunteers_session_path, params: { email_address: users(:emir).email_address, password: "wrong" }
    assert_redirected_to new_volunteers_session_path
    assert_nil cookies[:session_id]
  end

  test "an organizer cannot sign in from the volunteer page" do
    post volunteers_session_path, params: { email_address: users(:tema).email_address, password: "password" }

    assert_redirected_to new_volunteers_session_path
    assert_nil cookies[:session_id]
  end
end
