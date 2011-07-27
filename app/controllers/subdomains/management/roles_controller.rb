class Subdomains::Management::RolesController < SubdomainsController
  respond_to :html, :xml
  before_filter :authenticate, :collect_community_users
  before_filter :get_role_by_id, :only => [:edit, :update, :destroy]
  before_filter :sort_permissions, :only => [:edit, :update]

  def index
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @roles = @community.roles.all.delete_if{|role| not current_user.can_update(role)}
      @system_roles = []
      @custom_roles = []
      @roles.each do |role|
        if role.is_system_role?
          @system_roles.push(:role => role, :users => User.all.delete_if{|user| not user.roles.include?(role)})
        else
          @custom_roles.push(:role => role, :users => User.all.delete_if{|user| not user.roles.include?(role)})
        end
      end
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
    if !current_user.can_delete(@role) 
      render_insufficient_privileges
    else 
      if @role.destroy
        add_new_flash_message('Role was successfully deleted.')
        redirect_to(:back)
      end
    end
  end
  
  private
  
    def collect_community_users
      @users = @community.all_users
    end
    
    def get_role_by_id
      @role = @community.roles.find(params[:id])
    end
  
    def sort_permissions
      @permissions_global
      @permissions_pages
      @permissions_discussions
    end
end
