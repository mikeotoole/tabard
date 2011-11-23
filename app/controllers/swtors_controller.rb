class SwtorsController < ApplicationController
  respond_to :html, :js
###
# Before Filters
###
  skip_before_filter :authenticate_user!, :only => [:index]

###
# REST Actions
###
  # GET /swtors
  def index
    @communities = Community.includes(:supported_games).where{supported_games.game_type == "Swtor"}
  end
end
