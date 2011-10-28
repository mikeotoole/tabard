###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling discussions within the scope of subdomains (communities).
###
class Subdomains::DiscussionsController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :authenticate_user!
  before_filter :ensure_current_user_is_member
  load_and_authorize_resource :except => [:new, :create, :index]
  before_filter :create_discussion, :only => [:new, :create]
  before_filter :find_discussion_space_from_params
  authorize_resource :only => [:new, :create]
  skip_before_filter :limit_subdomain_access
  before_filter :ensure_active_profile_is_valid

###
# REST Actions
###
  # GET /discussion_spaces/:discussion_space_id/discussions(.:format)
  def index
    discussion_space = DiscussionSpace.find_by_id(params[:discussion_space_id])
    @discussions = discussion_space.discussions if discussion_space
    authorize! :read, discussion_space
  end

  # GET /discussions/:id(.:format)
  def show
    @discussion.update_viewed(current_user.user_profile)
    respond_to do |format|
      format.js { render text: "#{params['callback']}({\"result\":#{(current_user.has_seen?(@discussion) ? 'true' : 'false')}})", layout: false }
      format.html { redirect_to previous_page }
    end
  end

  # GET /discussion_spaces/:discussion_space_id/discussions/new(.:format)
  def new
  end

  # GET /discussions/:id/edit(.:format)
  def edit
    respond_with(@discussion)
  end

  # POST /discussion_spaces/:discussion_space_id/discussions(.:format)
  def create
    @discussion.user_profile = current_user.user_profile
    @discussion.character_proxy = (character_active? ? current_character.character_proxy : nil)
    add_new_flash_message('Discussion was successfully created.') if @discussion.save
    respond_with(@discussion)
  end

  # PUT /discussions/:id(.:format)
  def update
    if @discussion.update_attributes(params[:discussion])
      add_new_flash_message('Discussion was successfully updated.')
    end
    respond_with(@discussion)
  end

  # DELETE /discussions/:id(.:format)
  def destroy
    add_new_flash_message('Discussion was successfully deleted.') if @discussion.destroy
    respond_with(@discussion, :location => discussion_space_url(@discussion.discussion_space))
  end

###
# Added Actions
###
  # POST /discussions/:id/lock(.:format)
  def lock
    @discussion.has_been_locked = true
    if @discussion.save
      add_new_flash_message("Discussion was successfully locked.")
    else
      add_new_flash_message("Discussion was not locked, internal rails error.", 'alert')
    end
    redirect_to :back
    return
  end

  # POST /discussions/:id/unlock(.:format)
  def unlock
    @discussion.has_been_locked = false
    if @discussion.save
      add_new_flash_message("Discussion was successfully unlocked.")
    else
      add_new_flash_message("Discussion was not unlocked, internal rails error.", 'alert')
    end
    redirect_to :back
    return
  end

###
# Public Methods
###
  # This method returns the current game that is in scope.
  def current_game
    @discussion.discussion_space_game
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
  # This before filter attempts to create @discussion from: discussions.new(params[:discussion]), for the discussion space.
  ###
  def create_discussion
    discussion_space = DiscussionSpace.find_by_id(params[:discussion_space_id])
    @discussion = discussion_space.discussions.new(params[:discussion])
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to set the discussion space variable.
  ###
  def find_discussion_space_from_params
    @discussion_space = DiscussionSpace.find_by_id(params[:discussion_space_id]) if params[:discussion_space_id]
  end
end
