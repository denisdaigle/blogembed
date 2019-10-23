require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get pages_home_url
    assert_response :success
  end

  test "should get try" do
    get pages_try_url
    assert_response :success
  end

  test "should get login" do
    get pages_login_url
    assert_response :success
  end

end
