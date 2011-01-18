class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :create_api]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_back_or_default catalogue_movies_url(@user_session.record.catalogue)
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
  def create_api
	@user_session = UserSession.new(params)
	respond_to do |format|
	    if @user_session.save
			user = @user_session.record
			format.json { render :json => { :api_key => user.single_access_token, :catalogue => user.catalogue_id, :permissions => user.role_symbols } }
	    else
	        format.json { render :json => { :error => 402 } }
	    end
    end
  end
  
end
