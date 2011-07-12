class Management::RolesController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /management/roles
  # GET /management/roles.xml
  def index
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @roles = @community.roles.all
      respond_with(@roles)
    end
  end

  # GET /management/roles/1
  # GET /management/roles/1.xml
  def show
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else
      redirect_to :controller => 'management/roles', :action => 'edit', :id => params[:id]
      #@role = Role.find(params[:id])
      #respond_with(@role)
    end
  end

  # GET /management/roles/new
  # GET /management/roles/new.xml
  def new
    if !current_user.can_create("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.new
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
      render_insufficient_privileges
    else 
      @role = @community.roles.find(params[:id])
      @users = User.all
    end
  end

  # POST /management/roles
  # POST /management/roles.xml
  def create
    if !current_user.can_create("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.new(params[:role])
  
      if @role.save
        add_new_flash_message('Role was successfully created.')
      end
      redirect_to :controller => 'management/roles', :action => 'edit', :id => @role.id
      #respond_with([:management, @role])
    end
  end

  # PUT /management/roles/1
  # PUT /management/roles/1.xml
  def update
    if !current_user.can_update("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.find(params[:id])
      if @role.update_attributes(params[:role])
        add_new_flash_message('Role was successfully updated')
      end
      respond_with([:management, @role])
    end
  end

  # DELETE /management/roles/1
  # DELETE /management/roles/1.xml
  def destroy
    if !current_user.can_delete("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.find(params[:id])
      if @role.destroy
        add_new_flash_message('Role was successfully deleted.')
        redirect_to(:back)
      end
    end
  end
end
