class Catalogue < ActiveRecord::Base
  has_many :movie_holders
  has_many :revisions
  has_many :users
  
  def all_movies
    return movie_holders.collect { |m| m.movie }
  end
  
  def create_revision(movie_holder, data)
    revision = revisions.build(:catalogue_id => self.id)
    movie = revision.movies.build(data)
    if(movie_holder == nil)
		movie_holder = movie.build_movie_holder(:catalogue_id => self.id)
	else
		movie.movie_holder = movie_holder
	end
	if !revision.save
	    return false
	end
	movie_holder.movie = movie
    if !movie_holder.save
		return false
	end
	return true
  end
  
end
