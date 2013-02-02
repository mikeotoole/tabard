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
    @popular_games = Game.popular[0..4]
  end

  def create
    if @played_game.save
      flash[:success] = "The game has been added to your list."
    # else
    #  flash[:notice] = "That game is already on your list."
    end
    logger.debug @played_game.to_yaml
    redirect_to user_profile_url(@user_profile, anchor: "games", subdomain: "www")
  end

  def destroy
    @played_game.destroy
    redirect_to user_profile_url(@user_profile, anchor: "games", subdomain: "www")
  end

  # GET /played_games/autocomplete
  def autocomplete
    @games = Game.search(params[:term]).pluck(:name)
    render json: @games
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
