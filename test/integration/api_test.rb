require 'test_helper'

class ApiTest < ActionDispatch::IntegrationTest
  fixtures :all
  
  test "test get api key" do
    get_via_redirect "/user_sessions/create_api.json", :password => 'test', :login => 'test'
    assert_response :success
    assert_equal nil, JSON.parse(response.body)["error"]
    assert_equal '0l93SHddA0cfCPXusE7', JSON.parse(response.body)["api_key"]
    assert_equal 1, JSON.parse(response.body)["catalogue"]
    assert_equal ["admin"], JSON.parse(response.body)["permissions"]
  end
  
  test "test get api key guest" do
    get_via_redirect "/user_sessions/create_api.json", :password => 'test', :login => 'guest'
    assert_response :success
    assert_equal nil, JSON.parse(response.body)["error"]
    assert_equal '0l93SHddA0cfCPXusE1', JSON.parse(response.body)["api_key"]
    assert_equal 1, JSON.parse(response.body)["catalogue"]
    assert_equal ["read"], JSON.parse(response.body)["permissions"]
  end

  test "apiv1 update_many one" do
    name1 = 'test1'
    assert_equal 1, Movie.count
    post_via_redirect "/catalogues/1/apiv1/update_many.json", :movies => [{:data => { :name => name1 }}], :api_key => "0l93SHddA0cfCPXusE7"
    assert_response :success
    assert_equal "true", JSON.parse(response.body)["result"]
    assert_equal 2, Movie.count
    assert Movie.exists?(:name => name1), "Movie1 should exist"
    id = Movie.find_by_name(name1).id
    name2 = 'test2'
    post_via_redirect "/catalogues/1/apiv1/update_many.json", :movies => [{:id => id, :data => {:name => name2 }}], :api_key => "0l93SHddA0cfCPXusE7"
    assert_equal 2, Movie.count
    assert Movie.exists?(:name => name2), "Movie2 should exist"
  end

  test "apiv1 update_many two" do
    name1 = 'test1'
    name2 = 'test2'
    assert_equal 1, Movie.count
    post_via_redirect "/catalogues/1/apiv1/update_many.json", :movies => [{:data => { :name => name1 }},{:data => { :name => name2 }}], :api_key => "0l93SHddA0cfCPXusE7"
    assert_response :success
    assert_equal "true", JSON.parse(response.body)["result"]
    assert_equal 3, Movie.count
    assert Movie.exists?(:name => name1), "Movie1 should exist"
    assert Movie.exists?(:name => name2), "Movie2 should exist"
  end
  
  test "apiv1 new_revisions" do
    num = Revision.count
	get_via_redirect "/catalogues/1/apiv1/new_revisions.json", :number => 1, :api_key => "0l93SHddA0cfCPXusE7"
	assert_response :success
	assert_equal 1, JSON.parse(response.body)["movies"].length
	assert_equal 2, JSON.parse(response.body)["number"]
	get_via_redirect "/catalogues/1/apiv1/new_revisions.json", :number => 2, :api_key => "0l93SHddA0cfCPXusE7"
	assert_response :success
	assert_equal 0, JSON.parse(response.body)["movies"].length
  end
  
  test "apiv1 new_revisions with delete" do
    num = Revision.count
	get_via_redirect "/catalogues/1/apiv1/new_revisions.json", :number => 0, :api_key => "0l93SHddA0cfCPXusE7"
	assert_response :success
	assert_equal 2, JSON.parse(response.body)["number"]
	assert_equal 1, JSON.parse(response.body)["movies"].length
	assert_equal 1, JSON.parse(response.body)["deletes"].length
	get_via_redirect "/catalogues/1/apiv1/new_revisions.json", :number => 1, :api_key => "0l93SHddA0cfCPXusE7"
	assert_response :success
	assert_equal 1, JSON.parse(response.body)["movies"].length
	assert_equal 0, JSON.parse(response.body)["deletes"].length
  end
  
end
