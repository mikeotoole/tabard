=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is handling community announcements within the scope of subdomains (communities).
=end
class Subdomains::CommunityAnnouncementsController < SubdomainsController
  respond_to :html
  before_filter :authenticate

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

  def new
    @community_announcement = @community.community_announcements.new
    if !current_user.can_create(@community_announcement)
      render_insufficient_privileges
    else
      respond_with(@community_announcement)
    end
  end
  
  def edit
    @community_announcement = @community.community_announcements.find(params[:id])
    if !current_user.can_update(@community_announcement)
      render_insufficient_privileges
    else
      respond_with(@community_announcement)
    end
  end
  
  def create
    @community_announcement = @community.community_announcements.new(params[:community_announcement])
    if !current_user.can_create(@community_announcement)
      render_insufficient_privileges
    else
      if @community_announcement.save
        respond_with(@community_announcement)
      end
      grab_all_errors_from_model(@community_announcement)
      respond_with(@community_announcement)
    end
  end
  
  def update
    @community_announcement = @community.community_announcements.find(params[:id])
    if !current_user.can_update(@community_announcement)
      render_insufficient_privileges
    else
      if @community_announcement.update_attributes(params[:community_announcement])
        add_new_flash_message('Community announcement was successfully updated.')
      end
      grab_all_errors_from_model(@community_announcement)
      respond_with(@community_announcement)
    end
  end
  
  def destroy
    @community_announcement = @community.community_announcements.find(params[:id])
    if !current_user.can_delete(@community_announcement)
      render_insufficient_privileges
    else
      @community_announcement.destroy
      grab_all_errors_from_model(@community_announcement)
      respond_with(@community_announcement)
    end
  end

  private
  #Nested Resource Helper
  
end
