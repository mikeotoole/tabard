class SwtorCharactersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml, :js
    
  # GET /game/game_id/swtor_characters/1/edit
  def edit
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_update(@character)
        render :nothing => true, :status => :forbidden
    end
  end
  
  # GET /game/game_id/swtor_characters/1
  # GET /game/game_id/swtor_characters/1.xml
  def show
      @character = SwtorCharacter.find_by_id(params[:id])
      if !current_user.can_show(@character)
        render :nothing => true, :status => :forbidden
      else
        @game = Game.find_by_id(@character.game_id) if @character
    
        respond_with(@character)
      end
  end
  
  # GET /game/game_id/swtor_characters/new
  # GET /game/game_id/swtor_characters/new.xml
  def new
      @character = SwtorCharacter.new
      if !current_user.can_create(@character)
        render :nothing => true, :status => :forbidden
      else
        @character.game_id = params[:game_id]
        
        @gameProfile = GameProfile.new
        @proxy = CharacterProxy.new
    
        respond_with(@character)
      end
  end

  # POST /game/game_id/swtor_characters
  # POST /game/game_id/swtor_characters.xml
  def create
    @character = SwtorCharacter.new(params[:swtor_character])
    if !current_user.can_create(@character)
      render :nothing => true, :status => :forbidden
    else
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
          if params[:default]
            @gameProfile.default_character_proxy_id = @proxy.id
          end
          @gameProfile.save
          
          format.html { redirect_to([@character.game, @character], :notice => 'Character was successfully created.') }
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
      render :nothing => true, :status => :forbidden
    else
      @game = Game.find_by_id(@character.game_id) if @character
      
      if params[:default]
        @gameProfile = CharacterProxy.character_game_profile(@character)
        @gameProfile.default_character_proxy_id = @character.character_proxy_id if @gameProfile
        @gameProfile.save if @gameProfile
      end
  
      if @character.update_attributes(params[:swtor_character])
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

  # DELETE /game/game_id/swtor_characters/1
  # DELETE /game/game_id/swtor_characters/1.xml
  def destroy
    @character = SwtorCharacter.find_by_id(params[:id])
    if !current_user.can_delete(@character)
      render :nothing => true, :status => :forbidden
    else
      @character.destroy if @character
      
      respond_to do |format|
        format.html { redirect_to user_profile_path(UserProfile.find(current_user)), :notice => 'Character deleted' }
        format.xml  { head :ok }
      end
    end
  end
end
