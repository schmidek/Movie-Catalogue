class Catalogue < ActiveRecord::Base
  has_many :movie_holders
  has_many :revisions
  has_many :users
  
  def all_movies
    return movie_holders.collect { |m| m.movie }
  end
  
  def get_movies(page,limit,sidx,sord)
    offset = limit * (page -1)
    
    movies = 
    Movie.joins('LEFT OUTER JOIN movie_holders ON movie_holders.movie_id = movies.id')
         .where('movie_holders.catalogue_id' => self.id)
         .limit(limit).offset(offset)
         .order(sidx + " " + sord)
    count =
    Movie.joins('LEFT OUTER JOIN movie_holders ON movie_holders.movie_id = movies.id')
         .where('movie_holders.catalogue_id' => self.id)
         .count
    total_pages = (count.to_f/limit.to_f).ceil
    rows = Array.new(movies.length)
    movies.each_with_index { |m, i| rows[i] = {"id" => m.id, "cell" => [m.name,m.year,m.added] } }
         
    return {
		'records' => count,
		'page' => page,
		'total' => total_pages,
		'rows' => rows
    }
  end
  
  def create_revision(movie_holder, data)
    revision = revisions.build(:catalogue_id => self.id, :number => current_revision_number+1)
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
  
  def new_revisions(number)
  
	if current_revision_number <= number
	  return nil
	end
	revisions = revisions.includes(:movies => :movie_holder).where(["number > ?", number])
	out = Array.new(revisions.length)
	revisions.each_with_index { |r, i| out[i] = r.to_hash }
	return out
  
  end
  
  def current_revision_number
  
    number = revisions.maximum("number");
    return number ? number : 1;
  
  end
  
end