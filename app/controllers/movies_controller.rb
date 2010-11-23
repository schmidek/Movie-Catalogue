class MoviesController < ApplicationController
  before_filter :require_user, :require_catalogue
  protect_from_forgery :except=>:create
  
  def require_catalogue
	@catalogue = Catalogue.find(params[:catalogue_id])
  end

  # GET /movies
  # GET /movies.xml
  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def grid
	page = params[:page].to_i
	limit = params[:rows].to_i
	sidx = params[:sidx]
	sord = params[:sord]
	
	@movies = @catalogue.get_movies(page,limit,sidx,sord)
	
	respond_to do |format|
      format.json { render :json => @movies }
    end
  end
  
  def update_many
	begin
		#rescue ActiveRecord::StatementInvalid
		#ActiveRecord::RecordInvalid
		Movie.transaction do
			params[:movies].each do |m|
				data = m[:data]
				#gotta change genre name to id
				if(data.has_key?("genres"))
					ids = Genre.get_ids(data[:genres])
					data.delete("genres")
				end
				if(m.has_key?("id"))
					movie = @catalogue.movies.find(m[:id])
					movie.genre_ids = ids
					movie.changed_by = current_user
					movie.update_attributes(data)
				else
					movie = @catalogue.movies.build(data)
					movie.genre_ids = ids
					movie.changed_by = current_user
				end
			@catalogue.save!
			end
		end
	rescue
		respond_to do |format|
			format.json { render :json => { :result => "false", :reason => $!.to_s } }
		end
		return
	end
	respond_to do |format|
		format.json { render :json => { :result => "true" } }
	end
  
  end
  
  def pull
  
	revisions = current_user.catalogue.new_revisions
	
	respond_to do |format|
      format.json { render :json => { :result => "true" } }
    end
    
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = @catalogue.movies.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
      format.json { render :json => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = @catalogue.movies.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
	data = params[:movie]
    if(data.has_key?("genres"))
		ids = Genre.get_ids(data[:genres])
		data.delete("genres")
	end
    @movie = @catalogue.movies.build(data)
    @movie.changed_by = current_user
    unless ids == nil
		@movie.genre_ids = ids
    end

    respond_to do |format|
      if @movie.save
        format.html { redirect_to(@movie, :notice => 'Movie was successfully created.') }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
        format.json { render :json => {:success => true} }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
        format.json { render :json => {:success => false, :errors => @movie.errors} }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = @catalogue.movies.find(params[:id])
    @movie.changed_by = current_user
    
    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to(@movie, :notice => 'Movie was successfully updated.') }
        format.xml  { head :ok }
        format.json { render :json => {:success => true} }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
        format.json { render :json => {:success => false, :errors => @movie.errors} }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = @catalogue.movies.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
  
end
