require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "update api" do
    print "number: ", Movie.all.length
    name1 = 'test1'
    name2 = 'test2'
    post_via_redirect "/movies/update_many.json", :movies => [{ :name => name1 },{ :name => name2 }], :api_key => "0l93SHddA0cfCPXusE7"
    assert_response :success
    assert Movie.exists?(:name => name1), "Movie1 should exist"
    assert Movie.exists?(:name => name2), "Movie2 should exist"
  end
end
