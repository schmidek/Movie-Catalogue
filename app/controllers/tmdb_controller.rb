require 'xmlsimple'

class TmdbController < ApplicationController
  before_filter :require_user
  
  def search
		name = params[:name]
		movies = []
		if name =~ /(.+) [Ss]eason (\d+)/
			result = Net::HTTP.get_response(
				URI.parse("http://www.thetvdb.com/api/GetSeries.php?seriesname="+URI.escape($1)+"&language=en")
			)
			hash = XmlSimple.xml_in(result.body)
			if hash.has_key?('Series')
				series = hash['Series']
				movies = series.reject{|i| not i.class == Hash}.collect{|i| parseTvdb(i,$2)}
			end
		else
			result = Net::HTTP.get_response(
				URI.parse("http://api.themoviedb.org/2.1/Movie.search/en/json/"+Site::Application.config.tmdb_api_key+"/" + URI.escape(name))
			)
			hash = JSON.parse(result.body)
			movies = hash.reject{|i| not i.class == Hash}.collect{|i| parseTmdbMovie(i)}
        end
        
        render :json => movies
  end

  def getInfo
		id = params[:id]
		movie = Hash.new
		if id =~ /^__TVSHOW_SEASON_(\d+)__(\d+)/
			result = Net::HTTP.get_response(
				URI.parse("http://www.thetvdb.com/data/series/"+URI.escape($2)+"/")
			)
			hash = XmlSimple.xml_in(result.body)
			movie = parseTvdb(hash['Series'][0],$1);
			movie["name"] = movie["name"] + " Season " + $1
			
			#Get correct year for season
			result = Net::HTTP.get_response(
				URI.parse("http://www.thetvdb.com/data/series/"+URI.escape($2)+"/default/"+$1+"/1")
			)
			seasonhash = XmlSimple.xml_in(result.body)["Episode"][0]
			if seasonhash.has_key?("FirstAired")
				released = seasonhash["FirstAired"].to_s
				begin
					movie["year"] = Date.parse(released).year
				rescue Exception=>e
					logger.debug("Invalid date: "+released)
				end
			end
		else
			result = Net::HTTP.get_response(
				URI.parse("http://api.themoviedb.org/2.1/Movie.getInfo/en/json/"+Site::Application.config.tmdb_api_key+"/" + id)
            )
			array = JSON.parse(result.body)
			if array.length > 0
				movie = parseTmdbMovie(array[0])
			end
        end
        
        render :json => movie
  end
  
  def getCoversByImdbId
    id = params[:imdb]
	covers = []
	result = Net::HTTP.get_response(
		URI.parse("http://api.themoviedb.org/2.1/Movie.imdbLookup/en/json/"+Site::Application.config.tmdb_api_key+"/" + id)
    )
	array = JSON.parse(result.body)
	if array.length > 0
		movie = parseTmdbMovie(array[0])
		covers = movie["covers"]
	end
	render :json => covers
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
  
  def parseTvdb(hash,season)
	movie = Hash.new
	id = hash["id"][0]
	movie["id"] = "__TVSHOW_SEASON_"+season+"__" + id
	movie["name"] = hash["SeriesName"][0]
	if hash.has_key?("FirstAired")
		released = hash["FirstAired"][0].to_s
		begin
			movie["year"] = Date.parse(released).year
		rescue Exception=>e
			logger.debug("Invalid date: "+released)
		end
	end
	if hash.has_key?("Overview")
		movie["summary"] = hash["Overview"][0]
	end
	if hash.has_key?("IMDB_ID")
		movie["imdb"] = hash["IMDB_ID"][0]
	end
	if hash.has_key?("Genre")
		movie["genres"] = hash["Genre"][0].split('|')
	end
	movie["covers"] = ["http://www.thetvdb.com/banners/seasons/"+id+"-"+season+".jpg"]
	return movie
  end

end
