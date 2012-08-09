###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for roles.
###
class Subdomains::RolesController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :load_roles
  before_filter :create_role, only: [:new, :create]
  before_filter
  authorize_resource
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_current_user_is_member

  # GET /roles
  def index
    respond_with(@roles)
  end

  # GET /roles/new
  def new
    @role.setup_permission_defaults
    render partial: 'form', locals: { role: @role }
  end

  # GET /roles/edit
  def edit
    render partial: 'form', locals: { role: @role }
  end

  # POST /roles
  def create
    if @role.save
      respond_to do |format|
        format.html {
          add_new_flash_message "A new role named \"#{@role.name}\" has been created.", 'success'
          redirect_to roles_path
        }
        format.js {
          render json: { success: true, role: @role }
        }
      end
    else
      respond_to do |format|
        format.html {
          add_new_flash_message "Unable to create role.", 'alert'
          render :index
        }
        format.js {
          render json: { success: false, role: @role }
        }
      end
    end
  end

  # PUT /roles/1
  def update
    params[:role][:community_profile_ids] ||= Array.new unless @role.is_member_role?
    if @role.update_attributes(params[:role])
      respond_to do |format|
        format.html {
          add_new_flash_message "The \"#{@role.name}\" role has been saved.", 'success'
          redirect_to roles_path
        }
        format.js {
          render json: { success: true, role: @role }
        }
      end
    else
      respond_to do |format|
        format.html {
          add_new_flash_message "There was an error saving the \"#{@role.name}\" role.", 'alert'
          render :index
        }
        format.js {
          render json: { success: false, role: @role }
        }
      end
    end
  end

  # DELETE /roles/1
  def destroy
    role_name = @role.name
    if @role.destroy
      add_new_flash_message "The \"#{role_name}\" role has been deleted.", 'notice'
      redirect_to roles_path
    end
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This before filter attempts to populate @roles and @role from the current_community.
  ###
  def load_roles
    @roles = current_community.roles
    @role ||= current_community.roles.find_by_id(params[:id])
  end

  ###
  # _before_filter
  #
  # This before filter attempts to create @role from: roles.new(params[:role]) or roles.new(), for the current community.
  ###
  def create_role
    if(params[:role])
      @role = current_community.roles.new(params[:role])
    else
      @role = current_community.roles.new
    end
  end
end
