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
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  load_and_authorize_resource except: [:new, :create, :index]
  before_filter :create_discussion, only: [:new, :create]
  before_filter :find_discussion_space_from_params
  authorize_resource only: [:new, :create]

###
# REST Actions
###
  # GET /discussions/:id(.:format)
  def show
    @discussion.update_viewed(current_user.user_profile) unless params[:page]
    @comments = @discussion.comments.page params[:page]
    respond_to do |format|
      format.js {
        announcement = current_user.recent_unread_announcements.size > 0 ? render_to_string(partial: 'layouts/flash_message_announcement', locals: { discussion: current_user.recent_unread_announcements.first }) : ''
        render text: "#{params['callback']}({\"result\":#{(current_user.has_seen?(@discussion) ? 'true' : 'false')},\"announcement\":#{announcement.to_json}})", layout: false }
      format.html
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
    if @discussion.save
      flash[:success] = 'Discussion was successfully created.'
      set_last_posted_as((@discussion.charater_posted? ? @discussion.character : @discussion.user_profile))
    end
    respond_with(@discussion)
  end

  # PUT /discussions/:id(.:format)
  def update
    @discussion.assign_attributes(params[:discussion])
    params[:discussion][:has_been_edited] = true if @discussion.changed?
    if @discussion.update_attributes(params[:discussion])
      flash[:success] = 'Discussion was successfully updated.'
    end
    respond_with(@discussion)
  end

  # DELETE /discussions/:id(.:format)
  def destroy
    flash[:notice] = 'Discussion was successfully removed.' if @discussion.destroy
    respond_with(@discussion, location: discussion_space_url(@discussion.discussion_space))
  end

###
# Added Actions
###
  # POST /discussions/:id/lock(.:format)
  def lock
    @discussion.is_locked = true
    if @discussion.save
      flash[:notice] = "Discussion was successfully locked."
    else
      flash[:alert] = "Discussion was not locked, internal rails error."
    end
    redirect_to :back
    return
  end

  # POST /discussions/:id/unlock(.:format)
  def unlock
    @discussion.is_locked = false
    if @discussion.save
      flash[:notice] = "Discussion was successfully unlocked."
    else
      flash[:alert] = "Discussion was not unlocked, internal rails error."
    end
    redirect_to :back
    return
  end

###
# Public Methods
###
  # This method returns the current game that is in scope.
  def current_game
    @discussion.discussion_space_game if @discussion
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
