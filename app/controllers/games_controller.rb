=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for games.
=end
class GamesController < ApplicationController
  respond_to :html

  def show
    @game = Game.active.find(params[:id])
    respond_with(@game)
  end
end
