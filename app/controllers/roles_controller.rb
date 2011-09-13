###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for roles.
###
class RolesController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :load_role, :except => [:new, :create]
  before_filter :create_role, :only => [:new, :create]
  authorize_resource
  skip_before_filter :limit_subdomain_access

  # GET /roles
  # GET /roles.json
  def index
    #@roles = @community
    respond_with(@roles)
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    #@role = Role.find(params[:id])
    #respond_with(@role)
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    #@role = current_community.roles.new
    #respond_with(@role)
  end

  # GET /roles/1/edit
  def edit
    #@role = Role.find(params[:id])
    respond_with(@role)
  end

  # POST /roles
  # POST /roles.json
  def create
    #@role = Role.new(params[:role])
    if @role.save
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@role)
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    #@role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@role)
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    #@role = Role.find(params[:id])
    if @role.destroy
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@role)
  end

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
  # This before filter attempts to create @role from: roles.create(params[:role]) or roles.new(), for the current community.
  ###
  def create_role
    if(params[:role])
      @role = current_community.roles.new(params[:role])
    else
      @role = current_community.roles.new
    end
  end
end
