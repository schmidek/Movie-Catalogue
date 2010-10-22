class MovieInfo < ActiveRecord::Base
  validates :name, :presence => true
  belongs_to :movie
  belongs_to :revision
  
  def save_movie(newrevision)
    revision = newrevision
    if movie == nil
      movie = build_movie(:catalogue_id => revision.catalogue)
      save
    else
      movieinfo = MovieInfo.create(self)
      movie.movie_info = movieinfo
      movie.save
    end
  end
  
end
