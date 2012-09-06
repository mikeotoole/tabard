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
  before_filter :authorize_community_and_game, only: [:community, :game]
  authorize_resource except: [:community, :game]
  skip_before_filter :limit_subdomain_access
  load_and_authorize_resource through: :current_community, only: [:new, :create, :lock, :unlock, :destroy]

###
# REST Actions
###
  # GET /announcements/
  def index
    @announcements = current_community.announcements.includes(:community).ordered.page params[:page]
  end

  # GET /announcements/:id(.:format)
  def show
    @announcement = current_community.announcements.includes(:community).find_by_id(params[:id])
    if @announcement
      authorize!(:read, @announcement)
      current_community = Community.find_by_id(params[:community_id]) if params[:community_id]
      @announcement.update_viewed(current_user.user_profile)
      @user_profiles_have_seen = @announcement.user_profiles_have_seen.order('LOWER(display_name) ASC')
      @user_profiles_have_not_seen = @announcement.user_profiles_have_not_seen.order('LOWER(display_name) ASC')
      @comments = @announcement.comments.page params[:page]
      respond_to do |format|
        format.js {
          announcement = any_announcements_to_display? ? render_to_string(partial: 'layouts/flash_message_announcement', locals: { announcement: announcements_to_display.first }) : ''
          render text: announcement, layout: nil
        }
        format.html
      end
    else
      flash[:alert] = "Announcement not found."
      redirect_to community_announcements_url
    end
  end

  # GET /announcement_spaces/:announcement_space_id/announcements/new(.:format)
  def new
    @announcement = current_community.announcements.new()
    @announcement.supported_game_id = params[:game].to_i if params.has_key? 'game'
  end

  # POST /announcement_spaces/:announcement_space_id/announcements(.:format)
  def create
    @announcement.user_profile = current_user.user_profile

    if @announcement.save
      set_last_posted_as((@announcement.charater_posted? ? @announcement.character_proxy : @announcement.user_profile))
      flash[:success] = 'Announcement was successfully created.'
    end
    respond_with(@announcement)
  end

  # DELETE /announcements/:id(.:format)
  def destroy
    flash[:notice] = 'Announcement was successfully removed.' if @announcement.destroy
    respond_with(@announcement)
  end

###
# Added Actions
###

  # GET /announcements/community(.:format)
  def community
    @announcements = current_community.community_announcements.ordered
  end

  # GET /announcements/game/:id(.:format)
  def game
    @supported_game = current_community.supported_games.find_by_id(params[:id])
    if !!@supported_game
      @announcements = @supported_game.announcements.where(community_id: current_community.id).ordered
    else
      redirect_to not_found_url
    end
  end

  # POST /announcements/:id/lock(.:format)
  def lock
    @announcement.is_locked = true
    if @announcement.save
      flash[:notice] = "Announcement was successfully locked."
    else
      flash[:alert] = "Announcement was not locked, internal rails error."
    end
    redirect_to :back
    return
  end

  # POST /announcements/:id/unlock(.:format)
  def unlock
    @announcement.is_locked = false
    if @announcement.save
      flash[:notice] = "Announcement was successfully unlocked."
    else
      flash[:alert] =  "Announcement was not unlocked, internal error."
    end
    redirect_to :back
    return
  end

  # DELETE /announcements/batch_destroy/(.:format)
  def batch_destroy
    if params[:ids]
      delete_count = 0
      params[:ids].each do |id|
        if announcement = current_community.announcements.find_by_id(id[0].to_i) and can? :destroy, announcement
          delete_count += 1 if announcement.destroy
        end
      end
      if delete_count < params[:ids].size
        flash[:alert] = "#{help.pluralize(params[:ids].size - delete_count, 'announcement')} could not be located and/or removed at this time."
      else
        flash[:success] = "#{help.pluralize(delete_count, 'announcement')} removed."
      end
    end
    redirect_to announcements_url
  end

  #Before Filter
  def authorize_community_and_game
    authorize! :index, Announcement
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
