class Management::UsersController < ApplicationController
  before_filter :authenticate
  # GET /management/users
  # GET /management/users.xml
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

#  # GET /management/users/1
#  # GET /management/users/1.xml
#  def show
#    if !current_user.can_show("User") and User.find(params[:id]) != current_user
#      render :nothing => true, :status => :forbidden
#    else 
#      @user = User.find(params[:id])
#      @announcements = Announcement.all
#      
#      respond_to do |format|
#        format.html # show.html.erb
#        format.xml  { render :xml => @user }
#      end
#    end
#  end

  # GET /management/users/new
  # GET /management/users/new.xml
  def new
    @user = User.new
    @user.user_profile = UserProfile.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /management/users/1/edit
  def edit
    if !current_user.can_update("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
    end
  end

  # POST /management/users
  # POST /management/users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        @user.user_profile.set_active
        @user.user_profile.save
        format.html { redirect_to(management_users_path, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => login_path }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /management/users/1
  # PUT /management/users/1.xml
  def update
    if !current_user.can_update("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(management_users_path, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /management/users/1
  # DELETE /management/users/1.xml
  def destroy
    if !current_user.can_delete("User") 
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
      @user.destroy
  
      respond_to do |format|
        format.html { redirect_to(management_users_path) }
        format.xml  { head :ok }
      end
    end
  end
  
  def activate
    if !current_user.can_update("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
      @user.user_profile.set_active
      
      respond_to do |format|
        if @user.user_profile.save
          format.html { redirect_to(management_users_path, :notice => 'User was successfully activated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(management_users_path, :alert => 'Error making active.') }
          format.xml  { render :xml => @user.user_profile.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def deactivate
    if !current_user.can_update("User") and User.find(params[:id]) != current_user
      render :nothing => true, :status => :forbidden
    else 
      @user = User.find(params[:id])
      @user.user_profile.set_inactive
      
      respond_to do |format|
        if @user.user_profile.save
          format.html { redirect_to(management_users_path, :notice => 'User was successfully deactivated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(management_users_path, :alert => 'Error making inactive.') }
          format.xml  { render :xml => @user.user_profile.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end
