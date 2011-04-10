class WowCharactersController < ApplicationController
  before_filter :authenticate, :except => [:new]
  respond_to :html, :xml, :js
  
  # GET /game/game_id/wow_characters/1/edit
  def edit
    @character = WowCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
        render :nothing => true, :status => :forbidden
    end
  end
  
  # GET /game/game_id/wow_characters/1
  # GET /game/game_id/wow_characters/1.xml
  def show
      @character = WowCharacter.find_by_id(params[:id])
      if !current_user.can_show(@character)
        render :nothing => true, :status => :forbidden
      else
        @game = Game.find_by_id(@character.game_id) if @character
    
        respond_with(@character)
      end
  end
  
  # GET /game/game_id/wow_characters/new
  # GET /game/game_id/wow_characters/new.xml
  def new
      @character = WowCharacter.new
      #TODO fix this
      # if !format.js and !current_user.can_create(@character)
      #   render :nothing => true, :status => :forbidden
      # else
        @character.game_id = params[:game_id]
        
        @new_id = Time.now.to_f
  
        respond_with(@character)
      # end
  end

  # POST /game/game_id/wow_characters
  # POST /game/game_id/wow_characters.xml
  def create
    @character = WowCharacter.new(params[:wow_character])
    if !current_user.can_create(@character)
      render :nothing => true, :status => :forbidden
    else
      
      profile = UserProfile.find_by_user_id(current_user.id)
      profile.build_character(@character, params[:default])
  
      respond_to do |format|
        if profile.save
          format.html { redirect_to [@character.game, @character], :notice => 'Character was successfully created.' }#redirect_to([@character.game, @character], :notice => 'Character was successfully created.') }
          format.xml  { render :xml => @character, :status => :created, :location => @character }
        else
          flash[:notice] = profile.errors.full_messages.join(" | ")
          format.html { render :action => "new" }
          format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /game/game_id/wow_characters/1
  # PUT /game/game_id/wow_characters/1.xml
  def update
    @character = WowCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
      render :nothing => true, :status => :forbidden
    else
      @game = Game.find_by_id(@character.game_id) if @character
      
      if params[:default]
        @gameProfile = CharacterProxy.character_game_profile(@character)
        @gameProfile.default_character_proxy_id = @character.character_proxy_id if @gameProfile
        @gameProfile.save if @gameProfile
      end
  
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
  end

  # DELETE /game/game_id/wow_characters/1
  # DELETE /game/game_id/wow_characters/1.xml
  def destroy
    @character = WowCharacter.find_by_id(params[:id])
    if !current_user.can_delete(@character)
      render :nothing => true, :status => :forbidden
    else
      @character.destroy if @character
      
      respond_to do |format|
        format.html { redirect_to user_profile_path(UserProfile.find_by_id(current_user)), :notice => 'Character deleted' }
        format.xml  { head :ok }
      end
    end
  end
end
