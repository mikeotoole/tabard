class Management::RolesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :get_avalible_permissionables
  # GET /management/roles
  # GET /management/roles.xml
  def index
    if !current_user.can_show("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @roles = Role.all
      respond_with(@roles)
    end
  end

  # GET /management/roles/1
  # GET /management/roles/1.xml
  def show
    if !current_user.can_show("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
      respond_with(@role)
    end
  end

  # GET /management/roles/new
  # GET /management/roles/new.xml
  def new
    if !current_user.can_create("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.new
      @users = User.all
  
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @role }
      end
    end
  end

  # GET /management/roles/1/edit
  def edit
    if !current_user.can_update("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
      @permissions = @role.permissions
      @users = User.all
    end
  end

  # POST /management/roles
  # POST /management/roles.xml
  def create
    if !current_user.can_create("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.new(params[:role])
  
      if @role.save
        flash[:notice] = 'Role was successfully created.'
      end
      respond_with([:management, @role])
    end
  end

  # PUT /management/roles/1
  # PUT /management/roles/1.xml
  def update
    if !current_user.can_update("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
      if @role.update_attributes(params[:role])
        flash[:notice] = 'Role was successfully updated.'
      end
      respond_with([:management, @role])
    end
  end

  # DELETE /management/roles/1
  # DELETE /management/roles/1.xml
  def destroy
    if !current_user.can_show("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
      @role.destroy
      respond_with([:management, @role])
    end
  end
  
  def get_avalible_permissionables
    @permissions = Array.new() 
    for resource in SystemResource.all
      @permissions << Permission.new(:permissionable => resource, :name => resource.name, :show_p => false, :create_p => false, :update_p => false, :delete_p => false)
    end
    for discussionS in DiscussionSpace.all
      @permissions << Permission.new(:permissionable => discussionS, :name => discussionS.name, :show_p => false, :create_p => false, :update_p => false, :delete_p => false)
    end
    for pageS in PageSpace.all
      @permissions << Permission.new(:permissionable => pageS, :name => pageS.name, :show_p => false, :create_p => false, :update_p => false, :delete_p => false)
    end
  end
end
