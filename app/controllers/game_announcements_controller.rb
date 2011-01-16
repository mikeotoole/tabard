class GameAnnouncementsController < ApplicationController
  # GET /game_announcements
  # GET /game_announcements.xml
  def index
    @game_announcements = GameAnnouncement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_announcements }
    end
  end

  # GET /game_announcements/1
  # GET /game_announcements/1.xml
  def show
    @game_announcement = GameAnnouncement.find(params[:id])
    if @game_announcement.game_id != nil
      @game = Game.find(@game_announcement.game_id)
    end
    
    @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @game_announcement.id})

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_announcement }
    end
  end

  # GET /game_announcements/new
  # GET /game_announcements/new.xml
  def new
    @game_announcement = GameAnnouncement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_announcement }
    end
  end

  # GET /game_announcements/1/edit
  def edit
    @game_announcement = GameAnnouncement.find(params[:id])
  end

  # POST /game_announcements
  # POST /game_announcements.xml
  def create
    @game_announcement = GameAnnouncement.new(params[:game_announcement])
    @users = User.find(:all, :conditions => {:is_active => true})
    @game = Game.find(:first, :conditions => {:id => @game_announcement.game_id})

    respond_to do |format|
      if @game_announcement.save
        for user in @users
          @userprofile = UserProfile.find_by_id(user)
          if @userprofile != nil
            @gameprofile = @userprofile.game_profiles.find(:first, :conditions => {:game_id => @game.id})
            if @gameprofile != nil
              AcknowledgmentOfAnnouncement.create(:announcement_id => @game_announcement.id, :profile_id => @gameprofile.id, :acknowledged => false)
            end
          end
        end
        format.html { redirect_to(@game_announcement, :notice => 'Game announcement was successfully created.') }
        format.xml  { render :xml => @game_announcement, :status => :created, :location => @game_announcement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_announcements/1
  # PUT /game_announcements/1.xml
  def update
    @game_announcement = GameAnnouncement.find(params[:id])

    respond_to do |format|
      if @game_announcement.update_attributes(params[:game_announcement])
        format.html { redirect_to(@game_announcement, :notice => 'Game announcement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_announcement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_announcements/1
  # DELETE /game_announcements/1.xml
  def destroy
    @game_announcement = GameAnnouncement.find(params[:id])
    @game_announcement.destroy

    respond_to do |format|
      format.html { redirect_to(announcements_path) }
      format.xml  { head :ok }
    end
  end
end
