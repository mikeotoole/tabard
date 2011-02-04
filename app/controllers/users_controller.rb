class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  # GET /users
  # GET /users.xml
  def index
    if !current_user.can_show("User") 
      render :nothing => true, :status => :forbidden
    else 
      @users = User.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @users }
      end
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    if !current_user.can_show("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
      @acknowledgment_of_announcements = @user.unacknowledged_announcements
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  # GET /users/1/edit
  def edit
    if !current_user.can_update("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
    end
  end
end
