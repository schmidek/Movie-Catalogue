class MovieHolder < ActiveRecord::Base
  belongs_to :catalogue
  belongs_to :movie
end
