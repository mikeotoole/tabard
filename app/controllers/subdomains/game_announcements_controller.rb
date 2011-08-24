=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is handling game announcements within the scope of subdomains (communities).
=end
class Subdomains::GameAnnouncementsController < SubdomainsController
  respond_to :html
  before_filter :authenticate, :grab_game_from_game_id, :grab_avaliable_games

  def index
    @game_announcements = @community.game_announcements.all
    respond_with(@game_announcements)
  end

  def show
    @game_announcement = @community.game_announcements.find(params[:id])
    if !current_user.can_show(@game_announcement)
      render_insufficient_privileges
    else
      if @game_announcement.game_id != nil
        @game = Game.find(@game_announcement.game_id)
      end

      @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @game_announcement.id})
      respond_with(@game_announcement)
    end
  end

  def new
    @game_announcement = game_announcement_helper.new
    if !current_user.can_create(@game_announcement)
      render_insufficient_privileges
    else
      respond_with(@game_announcement)
    end
  end

  def edit
    @game_announcement = game_announcement_helper.find(params[:id])
    if !current_user.can_update(@game_announcement)
      render_insufficient_privileges
    else
      respond_with(@game_announcement)
    end
  end

  def create
    @game_announcement = game_announcement_helper.new(params[:game_announcement])
    if !current_user.can_create(@game_announcement)
      render_insufficient_privileges
    else
      @game_announcement.community = @community
      @game_announcement.user_profile = current_user.user_profile
      if @game_announcement.save
        add_new_flash_message('Game announcement was successfully created.')
      end
      grab_all_errors_from_model(@game_announcement)
      respond_with(@game_announcement)
    end
  end

  def update
    @game_announcement = GameAnnouncement.find(params[:id])
    if !current_user.can_update(@game_announcement)
      render_insufficient_privileges
    else
      if @game_announcement.update_attributes(params[:game_announcement])
        add_new_flash_message('Game announcement was successfully updated.')
      end
      grab_all_errors_from_model(@game_announcement)
      respond_with(@game_announcement)
    end
  end

  def destroy
    @game_announcement = GameAnnouncement.find(params[:id])
    if !current_user.can_delete(@game_announcement)
      render_insufficient_privileges
    else
      @game_announcement.destroy
      grab_all_errors_from_model(@game_announcement)
      respond_with(@game_announcement)
    end
  end

  private
  #Nested Resource Helper
  def game_announcement_helper
    @game ? @game.game_announcements : GameAnnouncement
  end

  def grab_game_from_game_id
    @game = Game.find_by_id(params[:game_id]) if params[:game_id]
  end

  def grab_avaliable_games
  	@avaliable_games = @community.games
  end
end
