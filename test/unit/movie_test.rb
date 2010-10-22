require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "can't save movie without a name" do
    movie = MovieInfo.new
    assert !movie.save, "Saved the movie without a title"
  end
  
  test "retrieve movieinfo by id" do
    movieinfo = MovieInfo.find(1);
    assert movieinfo, "Didn't find movieinfo"
    assert_equal( movieinfo.name, "Shrek", "MovieInfo name does not match" )
    assert movieinfo.movie, "Couldn't get corresponding movie"
    assert_equal( movieinfo.movie.id, 1, "Movie not correct for movie info" )
  end
  
  test "retrieve all movieinfos" do
    movieinfos = MovieInfo.all
    assert movieinfos, "Couldn't get movie infos"
    assert_equal( movieinfos.length, 2, "Number of movie infos found wrong" )
  end
  
  test "retrieve all movies in catalogue" do
    cat = Catalogue.find(1)
    movies = cat.movies
    assert_equal( movies.length, 1, "Catalogue has incorrect number of movies" )
    assert_equal( movies.first.movie_info.name, "Shrek", "name of movie wrong" )
  end
  
  test "add movie" do
    name = "Batman"
    movieinfo = MovieInfo.new
    movieinfo.name = name
    Movie.find_each do |movie|
      assert_not_equal(movie.movie_info.name, name, "should be no movie with name batman")
    end
    Movie.add(movieinfo)
    dbmovieinfo = MovieInfo.find_by_name(name)
    assert dbmovieinfo, "Should have found some movieinfos"
    assert_equal( dbmovieinfo.name, name, "MovieInfo was not saved")
    assert dbmovieinfo.movie, "Movie must exist for movieinfo"
    assert_equal( dbmovieinfo.movie.movie_info.name, name, "Movie not associated with movieinfo")
  end
  
end
