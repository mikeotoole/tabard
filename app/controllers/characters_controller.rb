class CharactersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml, :js
  
  # GET /characters/1/edit
  def edit
    @character = Character.find(params[:id])
  end
  
  # GET /characters/1
  # GET /characters/1.xml
  def show
      @character = Character.find(params[:id])
      @game = Game.find(@character.game_id)
  
      respond_with(@character)
  end
  
  # GET /characters/new
  # GET /characters/new.xml
  def new
      @character = Character.new
  
      respond_with(@character)
  end

  # POST /games/game_id/characters
  # POST /games/game_id/characters.xml
  def create
    @game = Game.find_by_id(params[:character][:game_id])
    @character = @game.characters.factory(@game.type, params[:character])

    respond_to do |format|
      if @character.save
        current_user.add_character(@character, params[:default_character])
        format.html { redirect_to user_profile_path(UserProfile.find(current_user)), :notice => 'Character was successfully created.' }
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
        flash[:notice] = 'Character was successfully updated.'
        respond_with(@character)
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
