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
  before_filter :load_discussion_space, except: [:new, :create, :index]
  before_filter :create_discussion_space, only: [:new, :create]
  authorize_resource except: [:index]
  after_filter :create_activity, only: [:update, :create]

###
# REST Actions
###
  # GET /discussion_spaces
  def index
    @discussion_spaces = Kaminari.paginate_array(current_community.discussion_spaces.includes(community_game: [:community]).reject{|d| !can? :show, d }).page params[:page]
  end

  # GET /discussion_spaces/1
  def show
    @discussions = Kaminari.paginate_array(@discussion_space.discussions.ordered.reject{|d| !can? :show, d }).page params[:page]
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
    if @discussion_space.save
      flash[:success] = 'Discussion space has been created.'
      @action = 'created'
    end
    respond_with(@discussion_space)
  end

  # PUT /discussion_spaces/1
  def update
    @discussion_space.assign_attributes(params[:discussion_space])
    is_changed = @discussion_space.changed?
    if @discussion_space.save
      flash[:success] = 'Discussion space has been saved.'
      @action = is_changed ? 'edited' : nil
    end
    respond_with(@discussion_space)
  end

  # DELETE /discussion_spaces/1
  def destroy
    flash[:notice] = 'Discussion space was successfully removed.' if @discussion_space.delay_destory
    respond_with(@discussion_space, location: discussion_spaces_path)
  end

###
# Helper Methods
###
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
    if @action
      Activity.create({user_profile: current_user.user_profile,
                      community: @discussion_space.community,
                      target: @discussion_space,
                      action: @action}, without_protection: true)
    end
  end
end
