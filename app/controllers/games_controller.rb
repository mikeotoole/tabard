###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for games.
###
class GamesController < ApplicationController
  respond_to :html
###
# Callbacks
###
  before_filter :block_unauthorized_user!, :except => :show
  before_filter :find_game, :only => :show
  authorize_resource

###
# REST Actions
###
  ###
  # This method gets the game.
  # GET /game/:id(.:format)
  # GET /games/:id(.:format)
  ###
  def show
  end

  # This method lets a game be found by pretty_url instead of id
  def find_game
    @game = Game.find_by_pretty_url(params[:id])
  end
end
