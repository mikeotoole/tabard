class RolesController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  # GET /roles
  # GET /roles.xml
  def index
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @roles = Role.all
      respond_with(@roles)
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    if !current_user.can_show("Role") 
      render_insufficient_privileges
    else 
      @role = Role.find(params[:id])
      respond_with(@role)
    end
  end
end
