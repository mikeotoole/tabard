require 'test_helper'

class ApplicationNotifierTest < ActionMailer::TestCase
  test "email_applicant" do
    mail = ApplicationNotifier.email_applicant
    assert_equal "Email applicant", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
