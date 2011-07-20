class Management::RolesController < Communities::CommunitiesController
  respond_to :html, :xml
  before_filter :authenticate

  def index
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @roles = @community.roles.all
      respond_with([:management, @roles])
    end
  end

  def show
    # TODO This is really messy and needs cleaning - JW
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else
      redirect_to :controller => 'management/roles', :action => 'edit', :id => params[:id]
      #@role = Role.find(params[:id])
      #respond_with(@role)
    end
  end

  def new
    if !current_user.can_create("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.new
      @users = User.all
      respond_with([:management,@role])
    end
  end

  def edit
    if !current_user.can_update("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.find(params[:id])
      @users = User.all
      respond_with([:management,@role])
    end
  end

  def create
    if !current_user.can_create("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.new(params[:role])
      if @role.save
        add_new_flash_message('Role was successfully created.')
      end
      grab_all_errors_from_model(@role)
      respond_with([:management,@role])
    end
  end

  def update
    if !current_user.can_update("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.find(params[:id])
      if @role.update_attributes(params[:role])
        add_new_flash_message('Role was successfully updated')
      end
      grab_all_errors_from_model(@role)
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
