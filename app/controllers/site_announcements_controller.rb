class SiteAnnouncementsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate
  
  # GET /site_announcements
  # GET /site_announcements.xml
  def index
    @site_announcements = SiteAnnouncement.all
    respond_with(@site_announcements)
  end

  # GET /site_announcements/1
  # GET /site_announcements/1.xml
  def show
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_show(@site_announcement)
      render :nothing => true, :status => :forbidden
    else
      @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @site_announcement.id})
      respond_with(@site_announcement)
    end
  end

  # GET /site_announcements/new
  # GET /site_announcements/new.xml
  def new
    @site_announcement = SiteAnnouncement.new
    if !current_user.can_create(@site_announcement)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@site_announcement)
    end 
  end

  # GET /site_announcements/1/edit
  def edit
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_update(@site_announcement)
      render :nothing => true, :status => :forbidden
    end
    respond_with(@site_announcement)
  end

  # POST /site_announcements
  # POST /site_announcements.xml
  def create
    @site_announcement = SiteAnnouncement.new(params[:site_announcement])
    if !current_user.can_create(@site_announcement)
      render :nothing => true, :status => :forbidden
    else
      if @site_announcement.save
        respond_with(@site_announcement)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @site_announcement.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /site_announcements/1
  # PUT /site_announcements/1.xml
  def update
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_update(@site_announcement)
      render :nothing => true, :status => :forbidden
    else
      if @site_announcement.update_attributes(params[:site_announcement])
        flash[:notice] = 'Site announcement was successfully updated.'
        respond_with(@site_announcement)
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @site_announcement.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /site_announcements/1
  # DELETE /site_announcements/1.xml
  def destroy
    @site_announcement = SiteAnnouncement.find(params[:id])
    if !current_user.can_delete(@site_announcement)
      render :nothing => true, :status => :forbidden
    else
      @site_announcement.destroy
      respond_with(@site_announcement)
    end
  end
end
