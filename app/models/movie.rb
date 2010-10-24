class Movie < ActiveRecord::Base
  validates :name, :presence => true
  belongs_to :movie_holder
  belongs_to :revision
end
