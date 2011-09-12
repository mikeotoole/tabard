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
  load_and_authorize_resource

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
end