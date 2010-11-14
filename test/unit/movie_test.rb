require 'test_helper'

class MovieTest < ActiveSupport::TestCase
  test "can't save movie without a name" do
    movie = Movie.new
    assert !movie.save, "Saved the movie without a title"
  end
  
  test "retrieve movieinfo by id" do
    movieinfo = Movie.find(1);
    assert movieinfo, "Didn't find movieinfo"
    assert_equal( movieinfo.name, "Shrek", "MovieInfo name does not match" )
    assert movieinfo.movie_holder, "Couldn't get corresponding movie"
    assert_equal( movieinfo.movie_holder.id, 1, "Movie not correct for movie info" )
  end
  
end
