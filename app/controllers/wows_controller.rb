###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for World of Warcraft games.
###
class WowsController < ApplicationController
  #caches_page :index
  #before_filter(only: [:index]) { @page_caching = true }
  respond_to :html, :js
###
# Before Filters
###
  skip_before_filter :block_unauthorized_user!, :only => [:index]

###
# REST Actions
###
  # GET /wows
  def index
    @communities = Community.includes(:supported_games).where{supported_games.game_type == "Wow"}.order('communities.name').page params[:page]
  end
end
