###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for handling a communities supported games.
###
class Subdomains::SupportedGamesController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_supported_game, :except => [:new, :create, :index]
  before_filter :create_supported_game, :only => [:new, :create]
  authorize_resource :except => [:index]
  skip_before_filter :limit_subdomain_access
  after_filter :create_activity, :only => [:update, :create]

###
# REST Actions
###
  # GET /supported_games
  def index
    @supported_games = current_community.supported_games
  end

  # GET /supported_games/new
  def new
  end

  # GET /supported_games/1/edit
  def edit
  end

  # POST /supported_games
  def create
    @supported_game.game = Game.get_game(params[:supported_game][:game_type], 
                                         params[:supported_game][:faction], 
                                         params[:supported_game][:server_name], 
                                         params[:supported_game][:server_type])

    if @supported_game.save
      add_new_flash_message 'Game has been added.', 'success'
      @action = 'created'
      redirect_to supported_games_url
    else
      respond_with(@supported_game)
    end
  end

  # PUT /supported_games/1
  def update
    @supported_game.game = Game.get_game(@supported_game.game_type, 
                                         params[:supported_game][:faction], 
                                         params[:supported_game][:server_name], 
                                         params[:supported_game][:server_type])

    @supported_game.assign_attributes(params[:supported_game])
    is_changed = @supported_game.changed?

    if @supported_game.save
      add_new_flash_message 'Game saved.', 'success'
      @action = is_changed ? 'edited' : nil
    end

    respond_with(@supported_game, :location => supported_games_url)
  end

  # DELETE /supported_games/1
  def destroy
    add_new_flash_message('Game was successfully removed.') if @supported_game.destroy
    respond_with(@supported_game)
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
  # This before filter attempts to populate @supported_game from the current_community.
  ###
  def load_supported_game
    @supported_game = current_community.supported_games.find_by_id(params[:id]) if current_community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @supported_game from: supported_games.new(params[:supported_game]), for the current community.
  ###
  def create_supported_game
    @supported_game = current_community.supported_games.new(params[:supported_game]) if current_community
  end

  ###
  # _after_filter_
  #
  # This after filter will created a new activty when a page is created or updated.
  ###
  def create_activity
    if @action
      Activity.create( :user_profile => current_user.user_profile,
                        :community => @supported_game.community,
                        :target => @supported_game,
                        :action => @action)
    end
  end
end
