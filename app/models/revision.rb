class Revision < ActiveRecord::Base
  has_many :movies
  belongs_to :catalogue
  
  def to_hash
  
	out = Array.new(movies.length)
	movies.each_with_index { |m, i| out[i] = {"id" => m.movie_holder.id, "data" => m } }
	return out;
  
  end
  
end
