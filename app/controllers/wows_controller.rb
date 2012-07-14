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
  skip_before_filter :block_unauthorized_user!, only: [:index]

###
# REST Actions
###
  # GET /wows
  def index
    @communities = Community.search(params[:search]).includes(:supported_games).where{supported_games.game_type == "Wow"}.order("communities."+sort_column + " " + sort_direction).page params[:page]
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
