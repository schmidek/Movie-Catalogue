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
	@revisions = @catalogue.new_revisions(params[:number])

    respond_to do |format|
		format.json { render :json => { :number => @catalogue.latest_revision,:movies => @revisions.collect{ |r| r.movie} }}
	end
  end

  def update_many
	begin
		#rescue ActiveRecord::StatementInvalid
		#ActiveRecord::RecordInvalid
		Movie.transaction do
			params[:movies].each do |m|
				data = m[:data]
				#change genre names to ids
				if(data.has_key?("genres"))
					ids = Genre.get_ids(data[:genres])
					data.delete("genres")
				end
				if(m.has_key?("id"))
					movie = @catalogue.movies.find(m[:id])
					if ids
						movie.genre_ids = ids
					end
					movie.update_attributes(data)
				else
					movie = @catalogue.movies.build(data)
					if ids
						movie.genre_ids = ids
					end
				end
			end
			@catalogue.save!
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
