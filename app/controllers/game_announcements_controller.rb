class GameAnnouncementsController < ApplicationController
  respond_to :html, :xml
  before_filter :authenticate, :grab_game_from_game_id
  
  # GET /game_announcements
  # GET /game_announcements.xml
  def index
    @game_announcements = GameAnnouncement.all
    respond_with(@game_announcements)
  end

  # GET /game_announcements/1
  # GET /game_announcements/1.xml
  def show
    @game_announcement = GameAnnouncement.find(params[:id])
    if !current_user.can_show(@game_announcement)
      render :nothing => true, :status => :forbidden
    else
      if @game_announcement.game_id != nil
        @game = Game.find(@game_announcement.game_id)
      end
      
      @acknowledgments = AcknowledgmentOfAnnouncement.find(:all, :conditions => {:announcement_id => @game_announcement.id})
      respond_with(@game_announcement)
    end
  end

  # GET /game_announcements/new
  # GET /game_announcements/new.xml
  def new
    @game_announcement = game_announcement_helper.new
    if !current_user.can_create(@game_announcement)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@game_announcement)
    end
  end

  # GET /game_announcements/1/edit
  def edit
    @game_announcement = game_announcement_helper.find(params[:id])
    if !current_user.can_update(@game_announcement)
      render :nothing => true, :status => :forbidden
    else
      respond_with(@game_announcement)
    end
  end

  # POST /game_announcements
  # POST /game_announcements.xml
  def create
    @game_announcement = game_announcement_helper.new(params[:game_announcement])
    if !current_user.can_create(@game_announcement)
      render :nothing => true, :status => :forbidden
    else 
      
      if @game_announcement.save
        respond_with(@game_announcement)
      else
        respond_to do |format|
          format.html { render :action => "new" }
          format.xml  { render :xml => @game_announcement.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /game_announcements/1
  # PUT /game_announcements/1.xml
  def update
    @game_announcement = GameAnnouncement.find(params[:id])
    if !current_user.can_update(@game_announcement)
      render :nothing => true, :status => :forbidden
    else
      if @game_announcement.update_attributes(params[:game_announcement])
        add_new_flash_message('Game announcement was successfully updated.')
        respond_with(@game_announcement)
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @game_announcement.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /game_announcements/1
  # DELETE /game_announcements/1.xml
  def destroy
    @game_announcement = GameAnnouncement.find(params[:id])
    if !current_user.can_delete(@game_announcement)
      render :nothing => true, :status => :forbidden
    else
      @game_announcement.destroy

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
end
