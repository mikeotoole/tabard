###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for handling a communities games.
###
class Subdomains::CommunityGamesController < SubdomainsController
  respond_to :html, :js

###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_community_game, except: [:new, :create, :index]
  before_filter :create_community_game, only: [:new, :create]
  authorize_resource except: [:index, :autocomplete]
  skip_before_filter :limit_subdomain_access
  after_filter :create_activity, only: [:update, :create]

###
# REST Actions
###
  # GET /community_games
  def index
    @community_games = current_community.community_games.includes(:community)
  end

  # GET /community_games/new
  def new
  end

  # GET /community_games/1/edit
  def edit
  end

  # POST /community_games
  def create
    if @community_game.save
      flash[:success] = 'Game has been added.'
      @action = 'created'
      redirect_to community_games_url
    else
      respond_with(@community_game)
    end
  end

  # PUT /community_games/1
  def update
    @community_game.assign_attributes(params[:community_game])
    is_changed = @community_game.changed?

    if @community_game.save
      flash[:success] = 'Game saved.'
      @action = is_changed ? 'edited' : nil
    end

    respond_with(@community_game, location: community_games_url)
  end

  # DELETE /community_games/1
  def destroy
    flash[:notice] = 'Game was successfully removed.' if @community_game.destroy
    respond_with(@community_game)
  end

  # GET /community_games/autocomplete(.:format)
  def autocomplete
    @games = Game.search(params[:term])
    @games = @games.map {|game|{
      value: game.name,
      type: game.type
    }}
    render json: @games
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This before filter attempts to populate @community_game from the current_community.
  ###
  def load_community_game
    @community_game = current_community.community_games.find_by_id(params[:id]) if current_community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @community_game from: community_games.new(params[:community_game]), for the current community.
  ###
  def create_community_game
    @community_game = current_community.community_games.new(params[:community_game]) if current_community
  end

  ###
  # _after_filter_
  #
  # This after filter will created a new activty when a page is created or updated.
  ###
  def create_activity
    if @action
      Activity.create( {user_profile: current_user.user_profile,
                        community: @community_game.community,
                        target: @community_game,
                        action: @action}, without_protection: true)
    end
  end
end
