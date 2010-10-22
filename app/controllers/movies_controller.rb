class MoviesController < ApplicationController
  before_filter :require_user

  # GET /movies
  # GET /movies.xml
  def index
    @movies = current_user.catalogue.all_movies

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = MovieInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = MovieInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = MovieInfo.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @movie = MovieInfo.new(params[:movie_info])

    respond_to do |format|
      if @movie.valid?
        current_user.catalogue.create_revision(@movie)
        format.html { redirect_to(movie_path(@movie), :notice => 'Movie was successfully created.') }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    dbmovie = MovieInfo.find(params[:id])
    @movie = MovieInfo.new(params[:id])
    @movie.movie = dbmovie.movie

    respond_to do |format|
      if @movie.valid?
        current_user.catalogue.create_revision(@movie)
        format.html { redirect_to(movie_path(@movie), :notice => 'Movie was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = MovieInfo.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
end
