require 'test_helper'

class BlogsControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get blogs_list_url
    assert_response :success
  end

end
