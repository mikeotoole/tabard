###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling discussion spaces within the scope of subdomains (communities).
###
class Subdomains::DiscussionSpacesController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_discussion_space, :except => [:new, :create, :index]
  before_filter :create_discussion_space, :only => [:new, :create]
  before_filter :setup_games_collection, :only => [:new, :edit]
  authorize_resource :except => :index
  skip_before_filter :limit_subdomain_access

###
# REST Actions
###
  # GET /discussion_spaces
  def index
    @discussion_spaces = current_community.discussion_spaces
  end

  # GET /discussion_spaces/1
  def show
  end

  # GET /discussion_spaces/new
  def new
  end

  # GET /discussion_spaces/1/edit
  def edit
    respond_with(@discussion_space)
  end

  # POST /discussion_spaces
  def create
    add_new_flash_message('Discussion space was successfully created.') if @discussion_space.save
    respond_with(@discussion_space)
  end

  # PUT /discussion_spaces/1
  def update
    if @discussion_space.update_attributes(params[:discussion_space])
      add_new_flash_message('Discussion space was successfully updated.')
    end
    respond_with(@discussion_space)
  end

  # DELETE /discussion_spaces/1
  def destroy
    add_new_flash_message('Discussion space was successfully deleted.') if @discussion_space.destroy
    respond_with(@discussion_space)
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
  # This before filter attempts to populate @discussion_space from the current_community.
  ###
  def load_discussion_space
    @discussion_space = current_community.discussion_spaces.find_by_id(params[:id]) if current_community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @discussion_space from: discussion_spaces.new(params[:custom_form]), for the current community.
  ###
  def create_discussion_space
    @discussion_space = current_community.discussion_spaces.new(params[:discussion_space]) if current_community
    @discussion_space.user_profile = current_user.user_profile if @discussion_space
  end
  
  ###
  # _before_filter_
  #
  # This before filter attempts to create a collection of games, with a blank first option for use in the form.
  ###
  def setup_games_collection
    @games_collection = [[ 'None', '' ]]
    @games_collection.concat(current_community.games.map{ |game| [game.name, game.id] })
  end
  
end
