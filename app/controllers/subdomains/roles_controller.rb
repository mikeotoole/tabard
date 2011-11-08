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
  before_filter :authenticate_user!
  before_filter :load_role, :except => [:new, :create]
  before_filter :create_role, :only => [:new, :create]
  authorize_resource
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_current_user_is_member

  # GET /roles
  def index
    respond_with(@roles)
  end

  # GET /roles/new
  def new
  end

  # GET /roles/1/edit
  def edit
    respond_with(@role)
  end

  # POST /roles
  def create
    if @role.save
      add_new_flash_message "A new role named \"#{@role.name}\" has been created.", 'notice'
    end
    respond_with(@role, :location => edit_role_path(@role))
  end

  # PUT /roles/1
  def update
    params[:role][:community_profile_ids] ||= Array.new
    if @role.update_attributes(params[:role])
      add_new_flash_message "The \"#{@role.name}\" role has been saved.", 'notice'
    end
    respond_with(@role, :location => edit_role_path(@role))
  end

  # DELETE /roles/1
  def destroy
    if @role.destroy
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@role)
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
  def load_role
    @roles = current_community.roles
    @role = current_community.roles.find_by_id(params[:id])
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
