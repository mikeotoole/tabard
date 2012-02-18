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
  authorize_resource :except => [:community, :game]
  skip_before_filter :limit_subdomain_access
  load_and_authorize_resource :through => :current_community, :only => [:show, :new, :create, :lock, :unlock, :destroy]

###
# REST Actions
###
  # GET /announcements/
  def index
    @announcements = current_community.announcements.ordered
  end

  # GET /announcements/:id(.:format)
  def show
    @announcement.update_viewed(current_user.user_profile)
    respond_to do |format|
      format.js {
        announcement = current_user.recent_unread_announcements.size > 0 ? render_to_string(:partial => 'layouts/flash_message_announcement', :locals => { :announcement => current_user.recent_unread_announcements.first }) : ''
        render :text => announcement, :layout => nil
      }
      format.html
    end
  end

  # GET /announcement_spaces/:announcement_space_id/announcements/new(.:format)
  def new
  end

  # POST /announcement_spaces/:announcement_space_id/announcements(.:format)
  def create
    @announcement.user_profile = current_user.user_profile

    if @announcement.save
      add_new_flash_message('Announcement was successfully created.','success')
    end 
    respond_with(@announcement)
  end

  # DELETE /announcements/:id(.:format)
  def destroy
    add_new_flash_message('Announcement was successfully removed.') if @announcement.destroy
    respond_with(@announcement)
  end

###
# Added Actions
###

  # GET /announcements/community(.:format)
  def community
    authorize! :index, Announcement
    @announcements = current_community.community_announcements.ordered
  end

  # GET /announcements/game/:id(.:format)
  def game
    authorize! :index, Announcement
    @supported_game = current_community.supported_games.find_by_id(params[:id])
    if !!@supported_game
      @announcements = @supported_game.announcements.non_community.ordered
    else
      redirect_to not_found_url
    end
  end

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
    @announcement.supported_game if @announcement and @announcement.persisted?
  end
  helper_method :current_game
end
