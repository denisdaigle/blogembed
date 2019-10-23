require 'test_helper'

class GeneralMailerTest < ActionMailer::TestCase
  test "general_email" do
    mail = GeneralMailer.general_email
    assert_equal "General email", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
