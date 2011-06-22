class GameLocationsController < ApplicationController
  # GET /game_locations
  # GET /game_locations.xml
  def index
    @game_locations = GameLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_locations }
    end
  end

  # GET /game_locations/1
  # GET /game_locations/1.xml
  def show
    @game_location = GameLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_location }
    end
  end

  # GET /game_locations/new
  # GET /game_locations/new.xml
  def new
    @game_location = GameLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_location }
    end
  end

  # GET /game_locations/1/edit
  def edit
    @game_location = GameLocation.find(params[:id])
  end

  # POST /game_locations
  # POST /game_locations.xml
  def create
    @game_location = GameLocation.new(params[:game_location])

    respond_to do |format|
      if @game_location.save
        add_new_flash_message('Game location was successfully created.')
        format.html { redirect_to(@game_location) }
        format.xml  { render :xml => @game_location, :status => :created, :location => @game_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_locations/1
  # PUT /game_locations/1.xml
  def update
    @game_location = GameLocation.find(params[:id])

    respond_to do |format|
      if @game_location.update_attributes(params[:game_location])
        add_new_flash_message('Game location was successfully updated.')
        format.html { redirect_to(@game_location) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_locations/1
  # DELETE /game_locations/1.xml
  def destroy
    @game_location = GameLocation.find(params[:id])
    @game_location.destroy

    respond_to do |format|
      format.html { redirect_to(game_locations_url) }
      format.xml  { head :ok }
    end
  end
end
