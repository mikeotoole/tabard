class SystemResourcesController < ApplicationController
  # GET /system_resources
  # GET /system_resources.xml
  def index
    @system_resources = SystemResource.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @system_resources }
    end
  end

  # GET /system_resources/1
  # GET /system_resources/1.xml
  def show
    @system_resource = SystemResource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @system_resource }
    end
  end

  # GET /system_resources/new
  # GET /system_resources/new.xml
  def new
    @system_resource = SystemResource.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @system_resource }
    end
  end

  # GET /system_resources/1/edit
  def edit
    @system_resource = SystemResource.find(params[:id])
  end

  # POST /system_resources
  # POST /system_resources.xml
  def create
    @system_resource = SystemResource.new(params[:system_resource])

    respond_to do |format|
      if @system_resource.save
        for role in Role.all
          if role.users.include?(current_user)
            role.permissions << Permission.new(:permissionable => @system_resource, :name => "Creator Permissions", :show_p => true, :create_p => true, :update_p => true, :delete_p => true) 
          else
            role.permissions << Permission.new(:permissionable => @system_resource, :name => @system_resource.name, :show_p => false, :create_p => false, :update_p => false, :delete_p => false)
          end
        end
        format.html { redirect_to(@system_resource, :notice => 'System resource was successfully created.') }
        format.xml  { render :xml => @system_resource, :status => :created, :location => @system_resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system_resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /system_resources/1
  # PUT /system_resources/1.xml
  def update
    @system_resource = SystemResource.find(params[:id])

    respond_to do |format|
      if @system_resource.update_attributes(params[:system_resource])
        format.html { redirect_to(@system_resource, :notice => 'System resource was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @system_resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /system_resources/1
  # DELETE /system_resources/1.xml
  def destroy
    @system_resource = SystemResource.find(params[:id])
    @system_resource.destroy

    respond_to do |format|
      format.html { redirect_to(system_resources_url) }
      format.xml  { head :ok }
    end
  end
end
