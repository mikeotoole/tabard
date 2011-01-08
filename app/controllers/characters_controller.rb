class CharactersController < ApplicationController
  # GET /characters/1/edit
  def edit
    @character = Character.find(params[:id])
  end
  
  # GET /characters/1
  # GET /characters/1.xml
  def show
      @character = Character.find(params[:id])
      @game = Game.find(@character.game_id)
  
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @character }
      end
  end
  
  # GET /characters/new
  # GET /characters/new.xml
  def new
      @character = Character.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @character }
      end
  end

  # POST /games/game_id/characters
  # POST /games/game_id/characters.xml
  def create
    @game = Game.find_by_id(params[:game][:game_id])
    @gameprofiles = current_user.user_profile.game_profiles
    @profile = @gameprofiles.find(:first, :conditions => { :game_id => @game.id })
    if @profile == nil
      user_profile = UserProfile.find(:first, :conditions => { :user_id => current_user.id})
      @profile = GameProfile.create(:game_id => @game.id, :user_profile_id => user_profile.id)
    end   
    
    @character = @game.characters.factory(@game.type, @game.id, @profile.id, params[:character])

    respond_to do |format|
      if @character.save
        format.html { redirect_to current_user.user_profile, :notice => 'Character was successfully created.' }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { redirect_to user_profile_path(UserProfile.find(current_user)), :alert => 'Unable to add character' }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/game_id/characters/1
  # PUT /games/game_id/characters/1.xml
  def update
    @character = Character.find(params[:id])
    @game = Game.find(@character.game_id)

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to(@character, :notice => 'Character was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/game_id/characters/1
  # DELETE /games/game_id/characters/1.xml
  def destroy
    @character = Character.find(params[:id])
    @character.destroy
    
    respond_to do |format|
      format.html { redirect_to user_profile_path(UserProfile.find(current_user)), :notice => 'Character deleted' }
      format.xml  { head :ok }
    end
  end
end
