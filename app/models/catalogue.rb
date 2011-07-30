class Catalogue < ActiveRecord::Base
  has_many :movies, :dependent => :destroy
  has_many :users
  has_many :revisions, :dependent => :nullify
  
  def all_movies
    return movies
  end
  
  def get_movies(page,limit,sidx,sord,name,year)
    offset = limit * (page -1)
     
    searched_movies = movies.where("active = ?",true)
    if name
		searched_movies = searched_movies.where("lower(name) LIKE ?",'%'+name.downcase+'%')
    end
    if year
		searched_movies = searched_movies.where("year = ?",year)
    end
    page_movies = searched_movies.limit(limit).offset(offset).order(sidx + " " + sord)
	count = searched_movies.count
     
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
  
  def get_revisions(page,limit,sidx,sord,type,movie,user)
	offset = limit * (page -1)
	search_revisions = revisions
	if type
		search_revisions = search_revisions.where("change_type = ?",type)
	end
	if movie
		search_revisions = search_revisions.joins(:movie).where("lower(movies.name) like ?",'%'+movie.downcase+'%')
	end
	if user
		search_revisions = search_revisions.joins(:user).where("lower(users.login) like ?",'%'+user.downcase+'%')
	end
	page_revisions = search_revisions.limit(limit).offset(offset).order(sidx + " " + sord).includes(:movie, :user)
	count = search_revisions.count
	
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
  
  def latest_revision
    return revisions.maximum("id")
  end
  
end
