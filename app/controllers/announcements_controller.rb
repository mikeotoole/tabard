class AnnouncementsController < ApplicationController
  respond_to :html
  before_filter :authenticate
  
  # GET /announcements
  # GET /announcements.xml
  def index
    @announcements = Announcement.all
    @site_announcements = Announcement.find(:all, :conditions => { :type => 'SiteAnnouncement' })
    @game_announcements = Announcement.find(:all, :conditions => { :type => 'GameAnnouncement' })
    
    respond_with(@announcements, @site_announcements, @game_announcements)
  end
end
