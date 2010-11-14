require 'test_helper'

class CatalogueTest < ActiveSupport::TestCase

  test "get all" do
    movies = Movie.all
    assert_equal( 1, movies.length, "Number of movies wrong")
    movies = Catalogue.find(1).all_movies
    assert_equal( 1, movies.length, "Number of movies for catalogue wrong")
    assert_equal( "Shrek", movies.first.name, "Name of first movie incorrect")
  end
  test "new movie" do
    result = Catalogue.find(1).create_revision(nil,{:name => "Shrek2"})
    assert( result, "create must be successfull")
    revisions = Revision.all
    assert_equal( 2, revisions.length, "Number of revisions wrong")
    movies = Movie.all
    assert_equal( 2, movies.length, "Number of movies wrong")
    movieholders = MovieHolder.all
    assert_equal( 2, movieholders.length, "Number of movie holders wrong")
    assert( Movie.find_by_name("Shrek2") != nil, "Shrek2 should be added")
    assert( Movie.find_by_name("Shrek2").movie_holder != nil, "Movie must have a movie_holder")
  end
  
  test "update movie" do
    movie = Movie.find(1)
    result = Catalogue.find(1).create_revision(movie.movie_holder,{:name => "Shrek2"})
    assert( result, "create must be successfull")
    revisions = Revision.all
    assert_equal( 2, revisions.length, "Number of revisions wrong")
    movies = Movie.all
    assert_equal( 2, movies.length, "Number of movies wrong")
    movieholders = MovieHolder.all
    assert_equal( 1, movieholders.length, "Number of movie holders wrong")
    assert_equal( "Shrek2", MovieHolder.find(1).movie.name, "Name should have been updated")
    assert( Movie.find_by_name("Shrek2") != nil, "Shrek2 should be added")
    assert( Movie.find_by_name("Shrek2").movie_holder != nil, "Movie must have a movie_holder")
  end
  
  #test "find the difference between two hashes" do
  #  assert_equal({:name => "aaa"}, {:name => "aaa"}.diff(Movie.find(1).attributes))
  #end
  
  test "get current revision number" do
	assert_equal(1, Catalogue.find(1).current_revision_number, "Revision numbers must match")
  end
  
end
