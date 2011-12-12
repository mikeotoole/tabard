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
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_discussion_space, :except => [:new, :create, :index]
  before_filter :create_discussion_space, :only => [:new, :create]
  authorize_resource :except => [:index, :index_announcement_spaces]
  skip_before_filter :limit_subdomain_access
  after_filter :create_activity, :only => [:update, :create]

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
    add_new_flash_message('Discussion space was successfully removed.') if @discussion_space.destroy
    respond_with(@discussion_space)
  end

  # This method returns the current game that is in scope.
  def current_game
    @discussion_space ? @discussion_space.game : nil
  end
  helper_method :current_game

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
  # This before filter attempts to create @discussion_space from: discussion_spaces.new(params[:discussion_space]), for the current community.
  ###
  def create_discussion_space
    @discussion_space = current_community.discussion_spaces.new(params[:discussion_space]) if current_community
  end
  
  ###
  # _after_filter_
  #
  # This after filter will created a new activty when a discussion space is created or updated.
  ###
  def create_activity
    if @discussion_space.valid? and @discussion_space.changed?
      action = @discussion_space.created_at == @discussion_space.updated_at ? "created" : "edited"
      
      Activity.create!( :user_profile => current_user.user_profile, 
                        :community => @discussion_space.community, 
                        :target => @discussion_space, 
                        :action => action)
    end                       
  end
end
