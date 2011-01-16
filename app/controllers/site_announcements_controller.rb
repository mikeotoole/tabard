class SiteAnnouncementsController < ApplicationController
  # GET /site_announcements
  # GET /site_announcements.xml
  def index
    @site_announcements = SiteAnnouncement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @site_announcements }
    end
  end

  # GET /site_announcements/1
  # GET /site_announcements/1.xml
  def show
    @site_announcement = SiteAnnouncement.find(params[:id])
    @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @site_announcement.id})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @site_announcement }
    end
  end

  # GET /site_announcements/new
  # GET /site_announcements/new.xml
  def new
    @site_announcement = SiteAnnouncement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @site_announcement }
    end
  end

  # GET /site_announcements/1/edit
  def edit
    @site_announcement = SiteAnnouncement.find(params[:id])
  end

  # POST /site_announcements
  # POST /site_announcements.xml
  def create
    @site_announcement = SiteAnnouncement.new(params[:site_announcement])
    @users = User.find(:all, :conditions => {:is_active => true})
    
    logger.debug "Number of users found: #{@users.count}"

    respond_to do |format|
      if @site_announcement.save
        for user in @users     
          @profile = UserProfile.find_by_id(user)
          if @profile != nil
            AcknowledgmentOfAnnouncement.create(:announcement_id => @site_announcement.id, :profile_id => @profile.id, :acknowledged => false)
          end
        end
        format.html { redirect_to(@site_announcement, :notice => 'Site announcement was successfully created.') }
        format.xml  { render :xml => @site_announcement, :status => :created, :location => @site_announcement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @site_announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /site_announcements/1
  # PUT /site_announcements/1.xml
  def update
    @site_announcement = SiteAnnouncement.find(params[:id])

    respond_to do |format|
      if @site_announcement.update_attributes(params[:site_announcement])
        format.html { redirect_to(@site_announcement, :notice => 'Site announcement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @site_announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /site_announcements/1
  # DELETE /site_announcements/1.xml
  def destroy
    @site_announcement = SiteAnnouncement.find(params[:id])
    @site_announcement.destroy

    respond_to do |format|
      format.html { redirect_to(announcements_path) }
      format.xml  { head :ok }
    end
  end
end
