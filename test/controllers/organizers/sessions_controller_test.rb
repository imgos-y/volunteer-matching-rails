require "test_helper"
class Organizers::SessionsControllerTest < ActionDispatch::IntegrationTest
test "new renders the sign in form" do
  get new_organizers_session_path

  assert_response :success
end

  test "create with valid credentials signs the organizer in" do
  post organizers_session_path, params: { email_address: users(:tema).email_address, password: "password" }

  assert_redirected_to root_url
  assert cookies[:session_id]
end

  test "create with wrong password does not sign the organizer in" do
  post organizers_session_path, params: { email_address: users(:tema).email_address, password: "wrong" }
  assert_redirected_to new_organizers_session_path
  assert_nil cookies[:session_id]
end

  test "an volunteer cannot sign in from the organizer page" do
  post organizers_session_path, params: { email_address: users(:emir).email_address, password: "password" }

  assert_redirected_to new_organizers_session_path
  assert_nil cookies[:session_id]
  end
end
