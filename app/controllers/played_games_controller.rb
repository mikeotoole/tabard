###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class PlayedGamesController < ApplicationController
  respond_to :html, :js
  skip_before_filter :block_unauthorized_user!
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
    @played_game.save
    respond_with [@user_profile, @played_game]
  end

end
