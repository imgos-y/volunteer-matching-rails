require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset" do
    user = users(:emir)

    mail = PasswordsMailer.reset(user)

    assert_equal [ user.email_address ], mail.to
    assert_equal [ "noreply@volunteer-matching.example" ], mail.from
    assert_equal "Reset your password", mail.subject
    assert_includes mail.text_part.body.to_s, "http://example.com/passwords/"
  end
end
