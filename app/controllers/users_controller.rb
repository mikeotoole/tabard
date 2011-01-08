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
      @announcements = Announcement.all
      
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @user }
      end
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
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

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        #Push them to the login page...
        format.html { redirect_to(login_path, :notice => 'User was successfully created. Please log in to finish your profile creation.') }
        format.xml  { render :xml => @user, :status => :created, :location => login_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if !current_user.can_update("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if !current_user.can_delete("User") 
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
      @user.destroy
  
      respond_to do |format|
        format.html { redirect_to(users_url) }
        format.xml  { head :ok }
      end
    end
  end
end
