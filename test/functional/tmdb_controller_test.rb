require 'test_helper'

class TmdbControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get getInfo" do
    get :getInfo
    assert_response :success
  end

end
