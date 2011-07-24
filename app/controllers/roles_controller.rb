class RolesController < Communities::CommunitiesController
  respond_to :html
  before_filter :authenticate

  def index
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @roles = @community.roles.all
      respond_with(@roles)
    end
  end

  def show
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @role = @community.roles.find(params[:id])
      respond_with(@role)
    end
  end
end
