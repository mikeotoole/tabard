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
    @communities = Community.search(params[:search]).includes(:supported_games).where{supported_games.game_type == "Minecraft"}.order("communities."+sort_column + " " + sort_direction).page params[:page]
  end

###
# Helper methods
###
  helper_method :sort_column, :sort_direction
private
  def sort_column
    Community.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
