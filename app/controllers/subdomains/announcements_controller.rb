###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling announcements within the scope of subdomains (communities).
###
class Subdomains::AnnouncementsController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  before_filter :create_announcement, :only => [:new, :create]
  authorize_resource
  skip_before_filter :limit_subdomain_access
  load_and_authorize_resource :through => :current_community, :only => [:show]

###
# REST Actions
###
  # GET /announcements/
  def index
    @announcements = current_community.announcements
  end

  def community
  end

  # GET /announcements/:id(.:format)
  def show
    @announcement.update_viewed(current_user.user_profile)
    respond_to do |format|
      format.js {
        announcement = current_user.recent_unread_announcements.size > 0 ? render_to_string(:partial => 'layouts/flash_message_announcement', :locals => { :discussion => current_user.recent_unread_announcements.first }) : ''
        render text: "#{params['callback']}({\"result\":#{(current_user.has_seen?(@announcement) ? 'true' : 'false')},\"announcement\":#{announcement.to_json}})", layout: false }
      format.html
    end
  end

  # GET /announcement_spaces/:announcement_space_id/announcements/new(.:format)
  def new
  end

  # GET /announcements/:id/edit(.:format)
  def edit
    respond_with(@announcement)
  end

  # POST /announcement_spaces/:announcement_space_id/announcements(.:format)
  def create
    @announcement.user_profile = current_user.user_profile
    @announcement.character_proxy = (character_active? ? current_character.character_proxy : nil)

    if @announcement.save
      add_new_flash_message('Announcement was successfully created.','success')
      next_location = {:location => announcement_url(@announcement)}
    else
      next_location = {:render => :new}
    end
    respond_with(@announcement, next_location)
  end

  # PUT /announcements/:id(.:format)
  def update
    params[:discussion][:has_been_edited] = true
    add_new_flash_message('Announcement saved.') if @announcement.update_attributes(params[:discussion])

    respond_with(@announcement, :render => :edit, :location => announcement_url)
  end

  # DELETE /announcements/:id(.:format)
  def destroy
    add_new_flash_message('Announcement was successfully removed.') if @announcement.destroy
    respond_with(@announcement, :location => announcement_space_url(@announcement_space))
  end

###
# Added Actions
###
  # POST /announcements/:id/lock(.:format)
  def lock
    @announcement.is_locked = true
    if @announcement.save
      add_new_flash_message("Announcement was successfully locked.")
    else
      add_new_flash_message("Announcement was not locked, internal rails error.", 'alert')
    end
    redirect_to :back
    return
  end

  # POST /announcements/:id/unlock(.:format)
  def unlock
    @announcement.is_locked = false
    if @announcement.save
      add_new_flash_message("Announcement was successfully unlocked.")
    else
      add_new_flash_message("Announcement was not unlocked, internal rails error.", 'alert')
    end
    redirect_to :back
    return
  end

###
# Public Methods
###
  # This method returns the current game that is in scope.
  def current_game
    @announcement.supported_game if @announcement
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
  # This before filter attempts to create @announcement from: announcements.new(params[:announcement]), for the announcement space.
  ###
  def create_announcement
    @announcement_space = DiscussionSpace.find_by_id(params[:announcement_space_id])
    @announcement = @announcement_space.discussions.new(params[:discussion])
  end
end
