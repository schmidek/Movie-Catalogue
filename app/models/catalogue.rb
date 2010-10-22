class Catalogue < ActiveRecord::Base
  has_many :movies
  has_many :revisions
  has_many :users
  
  def all_movies
    return MovieInfo.where({ :movie_id => movies })
  end
  
  def create_revision(movie_infos)
    revision = Revision.new
    revision.catalogue = self
    revision.save
    if movie_infos.kind_of?(Array)
    
    else
      movie_infos.save_movie(revision)
    end
  end
  
end
