class RolesController < ApplicationController
  before_filter :authenticate
  # GET /roles
  # GET /roles.xml
  def index
    if !current_user.can_show("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @roles = Role.all
    
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @roles }
      end
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    if !current_user.can_show("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @role }
      end
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    if !current_user.can_create("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.new
      @permissions = Array.new() 
      for resource in SystemResource.all
        @permissions << Permission.new(:permissionable => resource, :name => resource.name, :show_p => false, :create_p => false, :update_p => false, :delete_p => false)
      end
      @users = User.all
  
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @role }
      end
    end
  end

  # GET /roles/1/edit
  def edit
    if !current_user.can_update("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
      @permissions = @role.permissions
      @users = User.all
    end
  end

  # POST /roles
  # POST /roles.xml
  def create
    if !current_user.can_create("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.new(params[:role])
  
      respond_to do |format|
        if @role.save
          format.html { redirect_to(@role, :notice => 'Role was successfully created.') }
          format.xml  { render :xml => @role, :status => :created, :location => @role }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    if !current_user.can_update("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
  
      respond_to do |format|
        if @role.update_attributes(params[:role])
          format.html { redirect_to(@role, :notice => 'Role was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @role.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    if !current_user.can_show("Role") 
      render :nothing => true, :status => :forbidden
    else 
      @role = Role.find(params[:id])
      @role.destroy
  
      respond_to do |format|
        format.html { redirect_to(roles_url) }
        format.xml  { head :ok }
      end
    end
  end
end
