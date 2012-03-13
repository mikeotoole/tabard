###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Minecraft games.
###
class MinecraftsController < ApplicationController
  respond_to :html, :js
###
# Before Filters
###
  skip_before_filter :block_unauthorized_user!, :only => [:index]

###
# REST Actions
###
  # GET /minecrafts
  def index
    @communities = Community.includes(:supported_games).where{supported_games.game_type == "Minecraft"}.order('communities.name').page params[:page]
  end
end
