require 'test_helper'

class ConnectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get connect" do
    get connections_connect_url
    assert_response :success
  end

end
