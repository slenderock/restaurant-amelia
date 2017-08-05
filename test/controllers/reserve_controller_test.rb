require 'test_helper'

class ReserveControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get reserve_show_url
    assert_response :success
  end

end
