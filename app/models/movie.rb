class Movie < ActiveRecord::Base
  validates :name, :presence => true
  belongs_to :movie_holder
  belongs_to :revision
  
  def grid
	return { :page => 1 }
  end
  
end
