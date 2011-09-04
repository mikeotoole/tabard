###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for games.
###
class GamesController < ApplicationController
  ###
  # Before Filters
  ###
  before_filter :authenticate_user!

	#TODO Why is this not in the home/application controller?
  respond_to :html

	###
  # This method gets the game.
  # GET /game/:id(.:format) #TODO Why do we need this too?
  # GET /games/:id(.:format)
  ###
  def show
    @game = Game.active.find(params[:id])
    respond_with(@game)
  end
  
end
