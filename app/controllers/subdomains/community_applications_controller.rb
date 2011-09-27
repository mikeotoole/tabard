###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for roles.
###
class Subdomains::CommunityApplicationsController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :load_application, :except => [:new, :create]
  before_filter :create_application, :only => [:new, :create]
  authorize_resource
  skip_before_filter :limit_subdomain_access
  
  # GET /community_applications
  # GET /community_applications.json
  def index
    respond_with(@community_applications)
  end

  # GET /community_applications/1
  # GET /community_applications/1.json
  def show
  end

  # GET /community_applications/new
  # GET /community_applications/new.json
  def new
  end

  # GET /community_applications/1/edit
  def edit
    respond_with(@community_application)
  end

  # POST /community_applications
  # POST /community_applications.json
  def create
    if @community_application.save
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@community_application)
  end

  # PUT /community_applications/1
  # PUT /community_applications/1.json
  def update
    if @community_application.update_attributes(params[:community_application])
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@community_application)
  end

  # DELETE /community_applications/1
  # DELETE /community_applications/1.json
  def destroy
    if @community_application.destroy
      # TODO Doug/Joe Determine this success message, if applicable. -JW
    end
    respond_with(@community_application)
  end

  def accept
    @community_application.accept_application
    render :show
  end

  def reject
    @community_application.reject_application
    render :show
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
  # This before filter attempts to populate @community_applications and @community_application from the current_community.
  ###
  def load_application
    @community_applications = current_community.community_applications
    @community_application = current_community.community_applications.find_by_id(params[:id])
  end

  ###
  # _before_filter
  #
  # This before filter attempts to create @community_application from: community_applications.new(params[:community_application]) or community_applications.new(), for the current community.
  ###
  def create_application
    if(params[:community_application])
      @community_application = current_community.community_applications.new(params[:community_application])
    else
      @community_application = current_community.community_applications.new
    end
    @community_application.user_profile = current_user.user_profile
  end
end
