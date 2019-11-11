require 'test_helper'

class UpgradeControllerTest < ActionDispatch::IntegrationTest
  test "should get offer" do
    get upgrade_offer_url
    assert_response :success
  end

end
