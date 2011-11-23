class WowsController < ApplicationController
  respond_to :html, :js
###
# Before Filters
###
  skip_before_filter :authenticate_user!, :only => [:index]

###
# REST Actions
###
  # GET /wows
  def index
    @communities = Community.includes(:supported_games).where{supported_games.game_type == "Wow"}
  end
end
