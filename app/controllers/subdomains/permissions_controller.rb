###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for permissions.
###
class Subdomains::PermissionsController < SubdomainsController
  respond_to :html
  layout nil

###
# Before Filters
###
  before_filter :block_unauthorized_user!
  skip_before_filter :limit_subdomain_access
  before_filter :load_and_authorize_permissions_from_role, :only => [:index]
  load_and_authorize_resource :role, :except => [:index]
  load_and_authorize_resource :permission, :through =>:role, :except => [:index]
  before_filter :ensure_current_user_is_member

  # GET /permissions/new
  # GET /permissions/new.json
  def new
    @permission = Permission.new
    render :partial => 'subdomains/roles/permission', :locals => { :role => @role, :permission => @permission }
  end

  # POST /permissions
  # POST /permissions.json
  def create
    #@permission = Permission.new(params[:permission])
    @permission.save
    respond_with(@role,@permission)
  end

  # PUT /permissions/1
  # PUT /permissions/1.json
  def update
    #@permission = Permission.find(params[:id])
    @permission.update_attributes(params[:permission])
    respond_with(@role,@permission)
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.json
  def destroy
    #@permission = Permission.find(params[:id])
    @permission.destroy
    respond_with(@role, @permission)
  end

  # This method loads and authorizes permissions for index.
  def load_and_authorize_permissions_from_role
    @role = Role.find_by_id(params[:role_id])
    authorize! :show, @role
    if @role
      @permissions = @role.permissions.delete_if{ |permission| cannot? :view, permission }
    else
      @permissions = Array.new
    end
  end
end
