class Subdomains::Management::RolesController < SubdomainsController
  respond_to :html, :xml
  before_filter :authenticate
  before_filter :collect_community_users

  def index
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @roles = @community.roles.all.delete_if{|role| not current_user.can_update(role)}
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
    @role = @community.roles.new
    if !current_user.can_create(@role) 
      render_insufficient_privileges
    else
      respond_with([:management,@role])
    end
  end

  def edit
    @role = @community.roles.find(params[:id])
    if !current_user.can_update(@role) 
      render_insufficient_privileges
    else
      respond_with([:management,@role])
    end
  end

  def create
    @role = @community.roles.new(params[:role])
    if !current_user.can_create(@role) 
      render_insufficient_privileges
    else 
      if @role.save
        add_new_flash_message('Role was successfully created.')
      end
      grab_all_errors_from_model(@role)
      respond_with([:management,@role])
    end
  end

  def update
    @role = @community.roles.find(params[:id])
    if !current_user.can_update(@role) 
      render_insufficient_privileges
    else
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
    @role = @community.roles.find(params[:id])
    if !current_user.can_delete(@role) 
      render_insufficient_privileges
    else 
      if @role.destroy
        add_new_flash_message('Role was successfully deleted.')
        redirect_to(:back)
      end
    end
  end
  
  def collect_community_users
    @users = @community.all_users
  end
end
