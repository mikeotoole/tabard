=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is handling community announcements within the scope of subdomains (communities).
=end
class Subdomains::CommunityAnnouncementsController < SubdomainsController
  respond_to :html
  before_filter :authenticate, :grab_game_from_game_id

  def index
    @community_announcements = @community.community_announcements.all
    respond_with(@community_announcements)
  end

  def show
    @community_announcement = @community.community_announcements.find_by_id(params[:id])
    if !current_user.can_show(@community_announcement)
      render_insufficient_privileges
    else
      @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @community_announcement.id})
      respond_with(@community_announcement)
    end
  end

  #def new
  #  @game_announcement = game_announcement_helper.new
  #  if !current_user.can_create(@game_announcement)
  #    render_insufficient_privileges
  #  else
  #    respond_with(@game_announcement)
  #  end
  #end
  #
  #def edit
  #  @game_announcement = game_announcement_helper.find(params[:id])
  #  if !current_user.can_update(@game_announcement)
  #    render_insufficient_privileges
  #  else
  #    respond_with(@game_announcement)
  #  end
  #end
  #
  #def create
  #  @game_announcement = game_announcement_helper.new(params[:game_announcement])
  #  if !current_user.can_create(@game_announcement)
  #    render_insufficient_privileges
  #  else
  #    if @game_announcement.save
  #      respond_with(@game_announcement)
  #    end
  #    grab_all_errors_from_model(@game_announcement)
  #    respond_with(@game_announcement)
  #  end
  #end
  #
  #def update
  #  @game_announcement = GameAnnouncement.find(params[:id])
  #  if !current_user.can_update(@game_announcement)
  #    render_insufficient_privileges
  #  else
  #    if @game_announcement.update_attributes(params[:game_announcement])
  #      add_new_flash_message('Game announcement was successfully updated.')
  #    end
  #    grab_all_errors_from_model(@game_announcement)
  #    respond_with(@game_announcement)
  #  end
  #end
  #
  #def destroy
  #  @game_announcement = GameAnnouncement.find(params[:id])
  #  if !current_user.can_delete(@game_announcement)
  #    render_insufficient_privileges
  #  else
  #    @game_announcement.destroy
  #    grab_all_errors_from_model(@game_announcement)
  #    respond_with(@game_announcement)
  #  end
  #end

  private
  #Nested Resource Helper
  def game_announcement_helper
    @game ? @game.game_announcements : GameAnnouncement
  end

  def grab_game_from_game_id
    @game = Game.find_by_id(params[:game_id]) if params[:game_id]
  end
end
