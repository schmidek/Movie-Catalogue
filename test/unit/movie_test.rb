require 'test_helper'

class MovieTest < ActiveSupport::TestCase

  setup :initialize_user

  test "can't save movie without a name" do
    movie = Movie.new
    assert !movie.save, "Saved the movie without a title"
  end
  
  test "create" do
	movie = Movie.new(:name => "A")
	assert movie.save, "Save must be successful"
	dbmovie = Movie.find_by_name("A")
	assert dbmovie
	assert_equal("A", dbmovie.name)
	count = Revision.count
	assert_equal(2, count, "A revision must have been created")
	dbrevision = dbmovie.revisions.first
	assert dbrevision, "Revision must be linked to the movie"
	assert_equal("add", dbrevision.change_type)
  end
  
  test "update" do
	movie = Movie.find_by_name("Shrek")
	assert movie
	assert_equal(1, movie.revisions.length)
	movie.name = "B"
	assert movie.save, "Save must be successful"
	assert_equal("B", movie.name)
	assert_equal(2, movie.revisions.length, "A revision must have been created")
  end
  
  test "changes" do
	a = Movie.new
	a.name = "a"
	assert a.save, "Save must be successful"
	b = Movie.find_by_name("a")
	b.name = "b"
	assert b.changed?
	assert_equal(["name"],b.changed)
	diff = b.changes()
	assert_equal({"name" => ["a","b"]}, diff)
  end
  
  test "diff" do
	a = Movie.new
	a.name = "a"
	a.save
	a.name = "b"
	a.enable_dirty_associations do
	diff = a.diff
		assert_equal({"name" => [["a","b"]]}, diff)
	end
  end
  
  test "complex diff" do
	a = Movie.new
	a.name = "a"
	a.added = "2009-10-10"
	a.save
	a.name = "b"
	a.enable_dirty_associations do
		diff = a.diff
		assert_equal({"name" => [["a","b"]]}, diff)
	end
  end
  
  test "genre diff" do
	a = Movie.new
	a.name = "a"
	g1 = Genre.new
	g1.name = "agenre1"
	g1.save
	a.genres << g1
	a.save
	g2 = Genre.new
	g2.name = "agenre2"
	g2.save
	a.enable_dirty_associations do
		a.genres << g2
		diff = a.diff
		assert_equal({"genres" => ["agenre1", [nil, " agenre2"]]}, diff)
	end
  end
  
  private
  
  def initialize_user
	Authorization.current_user = User.first
  end
  
end
