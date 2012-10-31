###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class PlayedGamesController < ApplicationController
  respond_to :html, :js
  skip_before_filter :block_unauthorized_user!, only: [:show, :index]
  load_and_authorize_resource :user_profile, only: [:show, :index]
  before_filter :load_user_profile_from_current_user, except: [:show, :index]
  load_and_authorize_resource :played_game, through: :user_profile
  def index
    respond_with(@played_games) do |format|
      format.js {render partial: 'user_profiles/played_games', locals: { user_profile: @user_profile, played_games: @played_games }}
    end
  end

  def show
  end


  def new
  end

  def create
    if @played_game.save
      redirect_to user_profile_url(@user_profile, anchor: "played_games", subdomain: "www")
    else
      render :new
    end
  end

protected
  def load_user_profile_from_current_user
    if user_signed_in?
      @user_profile = current_user.user_profile
    else
      @user_profile = nil
    end
  end
end
