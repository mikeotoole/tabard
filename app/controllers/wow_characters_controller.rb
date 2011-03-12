class WowCharactersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml, :js
  
  # GET /game/game_id/wow_characters/1/edit
  def edit
    @character = WowCharacter.find_by_id(params[:id])
  end
  
  # GET /game/game_id/wow_characters/1
  # GET /game/game_id/wow_characters/1.xml
  def show
      @character = WowCharacter.find_by_id(params[:id])
      @game = Game.find_by_id(@character.game_id) if @character
  
      respond_with(@character)
  end
  
  # GET /game/game_id/wow_characters/new
  # GET /game/game_id/wow_characters/new.xml
  def new
      @character = WowCharacter.new
      @character.game_id = params[:game_id] 
  
      respond_with(@character)
  end

  # POST /game/game_id/wow_characters
  # POST /game/game_id/wow_characters.xml
  def create
    @character = WowCharacter.new(params[:wow_character])
    @game = Game.find_by_id(@character.game_id) if @character
    
    userProfile = current_user.user_profile
    @gameProfile = GameProfile.users_game_profile(userProfile, @game)
    
    if @gameProfile
      @proxy = CharacterProxy.new(:game_profile => @gameProfile, :character => @character)
    else
      @gameProfile = GameProfile.new(:game => @game, :user_profile => userProfile, :name => userProfile.name + " "+ @game.name + " Profile")
      @proxy = CharacterProxy.new(:game_profile => @gameProfile, :character => @character)
    end
    
    @proxy.valid?
    @character.valid?

    respond_to do |format|
      if @gameProfile.valid? and @proxy.valid? and @character.save
        @gameProfile.save
        @proxy.save
        
        format.html { redirect_to([@character.game, @character], :notice => 'Character was successfully created.') }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game/game_id/wow_characters/1
  # PUT /game/game_id/wow_characters/1.xml
  def update
    @character = WowCharacter.find_by_id(params[:id])
    @game = Game.find_by_id(@character.game_id) if @character

    if @character.update_attributes(params[:wow_character])
      flash[:notice] = 'Character was successfully updated.'
      respond_with(@game, @character)
    else
      respond_to do |format|
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game/game_id/wow_characters/1
  # DELETE /game/game_id/wow_characters/1.xml
  def destroy
    @character = WowCharacter.find_by_id(params[:id])
    @character.destroy if @character
    
    respond_to do |format|
      format.html { redirect_to user_profile_path(UserProfile.find_by_id(current_user)), :notice => 'Character deleted' }
      format.xml  { head :ok }
    end
  end
end
