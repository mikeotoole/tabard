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
  authorize_resource :except => :index
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_active_profile_is_valid # TODO Joe, Why is this needed? -MO

###
# REST Actions
###
  # GET /supported_games
  def index
    @supported_games = current_community.supported_games
  end

  # GET /supported_games/1
  def show
  end

  # GET /supported_games/new
  def new
  end

  # GET /supported_games/1/edit
  def edit
    @factions = @supported_game.game.all_factions
    @servers = @supported_game.game.all_servers
    respond_with(@supported_game)
  end

  # POST /supported_games
  def create
    game_class = params[:supported_game][:game_type].constantize
    game = game_class.game_for_faction_server(params[:supported_game][:faction], params[:supported_game][:server_name]) if game_class.superclass.name == "Game"
    if game
      @supported_game.game = game
    else
      @supported_game.game = game_class.new(:faction => params[:supported_game][:faction], :server_name => params[:supported_game][:server_name])  if game_class.superclass.name == "Game"
    end

    add_new_flash_message('Game was successfully added.') if @supported_game.save

    respond_with(@supported_game)
  end

  # PUT /supported_games/1
  def update
    game_class = @supported_game.game_type.constantize
    game = game_class.game_for_faction_server(params[:supported_game][:faction], params[:supported_game][:server_name]) if game_class.superclass.name == "Game"
    if not game
      game = game_class.new(:faction => params[:supported_game][:faction], :server_name => params[:supported_game][:server_name])  if game_class.superclass.name == "Game"
    end

    @supported_game.game = game

    if @supported_game.update_attributes(params[:supported_game])
      add_new_flash_message('Successfully updated.')
    end

    if not @supported_game.valid?
      @factions = @supported_game.game.all_factions
      @servers = @supported_game.game.all_servers
    end

    respond_with(@supported_game)
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
end
