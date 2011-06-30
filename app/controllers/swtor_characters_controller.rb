class SwtorCharactersController < ApplicationController
  before_filter :authenticate, :except => [:new]
  respond_to :html, :xml, :js
    
  # GET /game/game_id/swtor_characters/1/edit
  def edit
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
        render_insufficient_privileges
    end
  end
  
  # GET /game/game_id/swtor_characters/1
  # GET /game/game_id/swtor_characters/1.xml
  def show
      @character = SwtorCharacter.find_by_id(params[:id])
      if !current_user.can_show(@character)
        render_insufficient_privileges
      else
        @game = Game.find_by_id(@character.game_id) if @character
    
        respond_with(@character)
      end
  end
  
  # GET /game/game_id/swtor_characters/new
  # GET /game/game_id/swtor_characters/new.xml
  def new
      @character = SwtorCharacter.new
      #TODO fix this
      # if !current_user.can_create(@character)
      #   render :nothing => true, :status => :forbidden
      # else
        @character.game_id = params[:game_id]
    
        respond_with(@character)
      # end
  end

  # POST /game/game_id/swtor_characters
  # POST /game/game_id/swtor_characters.xml
  def create
    @character = SwtorCharacter.new(params[:swtor_character])
    if !current_user.can_create(@character)
      render_insufficient_privileges
    else
      profile = UserProfile.find_by_user_id(current_user.id)
      profile.build_character(@character, params[:default])
  
      respond_to do |format|
        if profile.save        
          add_new_flash_message('Character was successfully created.') 
          format.html { redirect_to([@character.game, @character]) }
          format.xml  { render :xml => @character, :status => :created, :location => @character }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /game/game_id/swtor_characters/1
  # PUT /game/game_id/swtor_characters/1.xml
  def update
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
      render_insufficient_privileges
    else
      @game = Game.find_by_id(@character.game_id) if @character
      
      if params[:default]
        @gameProfile = CharacterProxy.character_game_profile(@character)
        @gameProfile.default_character_proxy_id = @character.character_proxy_id if @gameProfile
        @gameProfile.save if @gameProfile
      end
  
      if @character.update_attributes(params[:swtor_character])
        add_new_flash_message('Character was successfully updated.')
        respond_with(@game, @character)
      else
        respond_to do |format|
          format.html { render :action => "edit" }
          format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /game/game_id/swtor_characters/1
  # DELETE /game/game_id/swtor_characters/1.xml
  def destroy
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_delete(@character)
      render_insufficient_privileges
    else
      @character.destroy if @character
      add_new_flash_message('Character was successfully deleted.') 
      respond_to do |format|
        format.html { redirect_to user_profile_path(UserProfile.find(current_user)) }
        format.xml  { head :ok }
      end
    end
  end
end
