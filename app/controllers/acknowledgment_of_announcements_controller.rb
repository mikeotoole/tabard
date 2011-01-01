class AcknowledgmentOfAnnouncementsController < ApplicationController
  # GET /acknowledgment_of_announcements
  # GET /acknowledgment_of_announcements.xml
  def index
    @acknowledgment_of_announcements = AcknowledgmentOfAnnouncement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @acknowledgment_of_announcements }
    end
  end

  # GET /acknowledgment_of_announcements/1
  # GET /acknowledgment_of_announcements/1.xml
  def show
    @acknowledgment_of_announcement = AcknowledgmentOfAnnouncement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @acknowledgment_of_announcement }
    end
  end

  # GET /acknowledgment_of_announcements/new
  # GET /acknowledgment_of_announcements/new.xml
  def new
    @acknowledgment_of_announcement = AcknowledgmentOfAnnouncement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @acknowledgment_of_announcement }
    end
  end

  # GET /acknowledgment_of_announcements/1/edit
  def edit
    @acknowledgment_of_announcement = AcknowledgmentOfAnnouncement.find(params[:id])
  end

  # POST /acknowledgment_of_announcements
  # POST /acknowledgment_of_announcements.xml
  def create
    @acknowledgment_of_announcement = AcknowledgmentOfAnnouncement.new(params[:acknowledgment_of_announcement])

    respond_to do |format|
      if @acknowledgment_of_announcement.save
        format.html { redirect_to(@acknowledgment_of_announcement, :notice => 'Acknowledgment of announcement was successfully created.') }
        format.xml  { render :xml => @acknowledgment_of_announcement, :status => :created, :location => @acknowledgment_of_announcement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @acknowledgment_of_announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /acknowledgment_of_announcements/1
  # PUT /acknowledgment_of_announcements/1.xml
  def update
    @acknowledgment_of_announcement = AcknowledgmentOfAnnouncement.find(params[:id])

    respond_to do |format|
      if @acknowledgment_of_announcement.update_attributes(params[:acknowledgment_of_announcement])
        format.html { redirect_to(@acknowledgment_of_announcement, :notice => 'Acknowledgment of announcement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @acknowledgment_of_announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /acknowledgment_of_announcements/1
  # DELETE /acknowledgment_of_announcements/1.xml
  def destroy
    @acknowledgment_of_announcement = AcknowledgmentOfAnnouncement.find(params[:id])
    @acknowledgment_of_announcement.destroy

    respond_to do |format|
      format.html { redirect_to(acknowledgment_of_announcements_url) }
      format.xml  { head :ok }
    end
  end
end
