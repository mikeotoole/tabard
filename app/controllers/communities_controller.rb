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
# Callbacks
###
  before_filter :authenticate_user!, :except => [:show, :index]

###
# REST Actions
###
  # GET /communities(.:format)
  def index
    @communities = Community.all
  end

  # GET /communities/:id(.:format)
  def show
    @community = Community.find(params[:id])
    redirect_to root_url(:subdomain => @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community = Community.new
  end

  # GET /communities/:id/edit(.:format)
  def edit
    @community = Community.find(params[:id])
  end

  # POST /communities(.:format)
  def create
    @community = Community.create(params[:community])
    respond_with(@community)
  end

  # PUT /communities/:id(.:format)
  def update
    @community = Community.find(params[:id])
    @community.update_attributes(params[:community])
    respond_with(@community)
  end
end
