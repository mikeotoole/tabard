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
  prepend_before_filter :authenticate_user!, :except => [:show, :index] #TODO Joe, is this right?
  before_filter :find_community, :only => [:show, :edit, :update]

###
# REST Actions
###
  # GET /communities(.:format)
  def index
    @communities = Community.all
  end

  # GET /communities/:id(.:format)
  def show
    redirect_to root_url(:subdomain => @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community = Community.new
  end

  # GET /communities/:id/edit(.:format)
  def edit
  end

  # POST /communities(.:format)
  def create
    @community = Community.create(params[:community])
    respond_with(@community)
  end

  # PUT /communities/:id(.:format)
  def update
    @community.update_attributes(params[:community])
    respond_with(@community)
  end

###
# Protected Methods
###
protected

  # Find community with given id.
  def find_community
    @community = Community.find(params[:id])
  end
end
