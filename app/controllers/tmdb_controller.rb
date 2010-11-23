class TmdbController < ApplicationController
  before_filter :require_user
  
  def search
		result = Net::HTTP.get_response(
            URI.parse("http://api.themoviedb.org/2.1/Movie.search/en/json/"+Site::Application.config.tmdb_api_key+"/" + URI.escape(params[:name]))
            )
        #render error if result. ...
        render :json => result.body
  end

  def getInfo
		result = Net::HTTP.get_response(
            URI.parse("http://api.themoviedb.org/2.1/Movie.getInfo/en/json/"+Site::Application.config.tmdb_api_key+"/" + params[:id])
            )
        #render error if result. ...
        render :json => result.body
  end

end
