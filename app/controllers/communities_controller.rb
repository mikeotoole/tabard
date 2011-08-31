###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source

# This controller is for communities.
###

class CommunitiesController < ApplicationController
  respond_to :html

  ###
  # Before Filters
  ###
  before_filter :find_community_by_subdomain, :only => :show
  before_filter :authenticate_user!, :except => [:show, :index]

  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    redirect_to [request.protocol, request.domain, request.port_string].join, :alert => "That community does not exist" and return false unless @community
  end

  # GET /communities
  # GET /communities.xml
  def index
    @communities = Community.all
  end

  # GET /communities/1
  # GET /communities/1.xml
  def show
    @community = Community.find(params[:id]) if params[:id]
  end

  # GET /communities/new
  # GET /communities/new.xml
  def new
    @community = Community.new
  end

  # GET /communities/1/edit
  def edit
    @community = Community.find(params[:id])
  end

  # POST /communities
  # POST /communities.xml
  def create
    @community = Community.new(params[:community])
  end

  # PUT /communities/1
  # PUT /communities/1.xml
  def update
    @community = Community.find(params[:id])
  end

end
