###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Star Wars: The Old Republic games.
###
class SwtorsController < ApplicationController
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
  # GET /swtors
  def index
    @communities = Community.includes(:supported_games).where{supported_games.game_type == "Swtor"}.order('communities.name').page params[:page]
  end
end
