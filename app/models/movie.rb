class Movie < ActiveRecord::Base
  belongs_to :catalogue
  belongs_to :movie_info
  
end
