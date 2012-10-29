###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class PlayedGamesController < ApplicationController
  respond_to :html, :js

  load_and_authorize_resource :user_profile
  load_and_authorize_resource :played_game, through: :user_profile
  def index
    respond_with(@played_games) do |format|
      format.js {render partial: 'user_profiles/played_games', locals: { user_profile: @user_profile, played_games: @played_games }}
    end
  end

  def new
  end

  def create
    game_name = params[:game_name]
    #@game = Game.where{name == game_name}.limit(1).first
    if @game.blank?
      # TODO Create on the fly
    end
    @played_game.game = @game
    @played_game.save
    respond_with [@user_profile, @played_game]
  end

end
