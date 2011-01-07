class Apiv1Controller < ApplicationController
  before_filter :require_user, :require_catalogue
  filter_access_to :new_revisions do
	permitted_to!(:show, @catalogue)
  end
  filter_access_to :update_many do
    permitted_to!(:edit, @catalogue)
  end

  def require_catalogue
	@catalogue = Catalogue.find(params[:catalogue_id])
  end

  def new_revisions
	@catalogue = Catalogue.find(params[:id])
	@revisions = @catalogue.new_revisions(params[:number])

    respond_to do |format|
		format.json { render :json => @revisions }
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
					movie.update_attributes(data)
				else
					movie = @catalogue.movies.build(data)
					movie.genre_ids = ids
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

end
