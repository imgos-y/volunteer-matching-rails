require "application_system_test_case"

class NavbarsTest < ApplicationSystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 375, 800 ]

  test "mobile menu opens, closes, and keeps working after a Turbo visit" do
    visit root_path
    assert_no_link "Volunteer Sign In"

    click_on "Menu"
    assert_link "Volunteer Sign In"
    assert_selector "button[aria-expanded='true']"

    click_on "Menu"
    assert_no_link "Volunteer Sign In"

    click_on "Menu"
    click_on "Organizer Sign In"
    assert_selector "h2", text: "Organizer Log in"

    click_on "Menu"
    assert_link "Volunteer Sign In"
  end
end
