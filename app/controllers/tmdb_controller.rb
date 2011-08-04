class TmdbController < ApplicationController
  before_filter :require_user
  
  def search
		result = Net::HTTP.get_response(
            URI.parse("http://api.themoviedb.org/2.1/Movie.search/en/json/"+Site::Application.config.tmdb_api_key+"/" + URI.escape(params[:name]))
            )
        #render error if result. ...
        hash = JSON.parse(result.body)
        
        render :json => hash.collect{|i| parseTmdbMovie(i)}
  end

  def getInfo
		result = Net::HTTP.get_response(
            URI.parse("http://api.themoviedb.org/2.1/Movie.getInfo/en/json/"+Site::Application.config.tmdb_api_key+"/" + params[:id])
            )
        #render error if result. ...
        array = JSON.parse(result.body)
        if array.length > 0
			render :json => parseTmdbMovie(array[0])
        end
  end
  
  private
  
  def parseTmdbMovie(hash)
	movie = Hash.new
	movie["id"] = hash["id"]
	movie["name"] = hash["name"]
	movie["imdb"] = hash["imdb_id"]
	if hash.has_key?("released")
		released = hash["released"].to_s
		begin
			movie["year"] = Date.parse(released).year
		rescue Exception=>e
			logger.debug("Invalid date: "+released)
		end
	end
	if hash.has_key?("trailer")
		movie["trailer"] = hash["trailer"]
	end
	if hash.has_key?("overview")
		movie["summary"] = hash["overview"]
	end
	if hash.has_key?("genres")
		movie["genres"] = hash["genres"].collect{|g| g["name"]}
	end
	if hash.has_key?("posters")
		covers = hash["posters"].select{|p| p["image"]["size"] == "cover"}
		if covers
			movie["covers"] = covers.collect{|p| p["image"]["url"]}
		end
	end
	return movie
  end

end
