class Catalogue < ActiveRecord::Base
  has_many :movies, :dependent => :destroy
  has_many :users
  has_many :revisions, :dependent => :nullify
  
  def all_movies
    return movies
  end
  
  def get_movies(page,limit,sidx,sord)
    offset = limit * (page -1)
    
#    movies = 
#    Movie.joins('LEFT OUTER JOIN movie_holders ON movie_holders.movie_id = movies.id')
#         .where('movie_holders.catalogue_id' => self.id)
#         .limit(limit).offset(offset)
#         .order(sidx + " " + sord)
#    count =
#    Movie.joins('LEFT OUTER JOIN movie_holders ON movie_holders.movie_id = movies.id')
#         .where('movie_holders.catalogue_id' => self.id)
#         .count
     
    page_movies = movies.limit(limit).offset(offset).order(sidx + " " + 
sord)
	count = movies.count
     
    total_pages = (count.to_f/limit.to_f).ceil
    rows = Array.new(page_movies.length)
    page_movies.each_with_index { |m, i| rows[i] = {"id" => m.id, "cell" => [m.name,m.year,m.added.strftime("%b %d, %Y at %I:%M%p")] } }
         
    return {
		'records' => count,
		'page' => page,
		'total' => total_pages,
		'rows' => rows
    }
  end
  
  def get_revisions(page,limit,sidx,sord)
	offset = limit * (page -1)
	page_revisions = 
	revisions.limit(limit).offset(offset).order(sidx + " " + sord).includes(:movie, :user)
	count = revisions.count
	
	total_pages = (count.to_f/limit.to_f).ceil
    rows = Array.new(page_revisions.length)
    page_revisions.each_with_index { |r, i| rows[i] = {"id" => r.id, "cell" => [r.change_type,r.movie.name,r.format_diff(:html),r.user.login,r.created_at.strftime("%b %d, %Y at %I:%M%p")] } }
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
  
    return revisions.where(["id > ?", number])
  
  end
  
end
