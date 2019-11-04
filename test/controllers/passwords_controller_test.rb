require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "should get request_reset_password_link" do
    get passwords_request_reset_password_link_url
    assert_response :success
  end

end
