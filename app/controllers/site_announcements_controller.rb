class SiteAnnouncementsController < ApplicationController
  respond_to :html
  before_filter :authenticate

  def index
    @site_announcements = SiteAnnouncement.all
    respond_with(@site_announcements)
  end

  def show
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_show(@site_announcement)
      render_insufficient_privileges
    else
      @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @site_announcement.id})
      respond_with(@site_announcement)
    end
  end

  def new
    @site_announcement = SiteAnnouncement.new
    if !current_user.can_create(@site_announcement)
      render_insufficient_privileges
    else
      respond_with(@site_announcement)
    end 
  end

  def edit
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_update(@site_announcement)
      render_insufficient_privileges
    end
    respond_with(@site_announcement)
  end

  def create
    @site_announcement = SiteAnnouncement.new(params[:site_announcement])
    if !current_user.can_create(@site_announcement)
      render_insufficient_privileges
    else
      if @site_announcement.save
        add_new_flash_message("Site Announement created.")
      end
      grab_all_errors_from_model(@site_announcement)
      respond_with(@site_announcement)
    end
  end

  def update
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_update(@site_announcement)
      render_insufficient_privileges
    else
      if @site_announcement.update_attributes(params[:site_announcement])
        add_new_flash_message('Site announcement was successfully updated.')
      end
      grab_all_errors_from_model(@site_announcement)
      respond_with(@site_announcement)
    end
  end

  def destroy
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_delete(@site_announcement)
      render_insufficient_privileges
    else
      @site_announcement.destroy
      respond_with(@site_announcement)
    end
  end
end
