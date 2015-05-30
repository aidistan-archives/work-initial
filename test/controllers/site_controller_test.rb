require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get record" do
    get :record
    assert_response :success
  end

  test "should get display" do
    get :display
    assert_response :success
  end

end
