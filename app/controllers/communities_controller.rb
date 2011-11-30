###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class CommunitiesController < ApplicationController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, :except => [:show, :index]
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => [:create]

###
# REST Actions
###
  # GET /communities(.:format)
  def index
  end

  # GET /communities/:id(.:format)
  def show
    redirect_to root_url(:subdomain => @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community.admin_profile = current_user.user_profile
  end

  # GET /communities/:id/edit(.:format)
  def edit
  end

  # POST /communities(.:format)
  def create
    @community = Community.new(params[:community])
    @community.admin_profile = current_user.user_profile
    authorize! :create, @community
    @community.save
    respond_with(@community)
  end

  # PUT /communities/:id(.:format)
  def update
    @community.update_attributes(params[:community])
    respond_with(@community)
  end

end
