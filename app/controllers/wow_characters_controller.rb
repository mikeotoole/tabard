class WowCharactersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml, :js
  
  def index
    @characters = WowCharacter.all
  end
  
  # GET /wow_characters/1/edit
  def edit
    @character = WowCharacter.find_by_id(params[:id])
  end
  
  # GET /wow_characters/1
  # GET /wow_characters/1.xml
  def show
      @character = WowCharacter.find_by_id(params[:id])
      @game = Game.find_by_id(@character.game_id) if @character
  
      respond_with(@character)
  end
  
  # GET /wow_characters/new
  # GET /wow_characters/new.xml
  def new
      @character = WowCharacter.new
      @character.game_id = params[:game_id]      
  
      respond_with(@character)
  end

  # POST /wow_characters
  # POST /wow_characters.xml
  def create
    @character = WowCharacter.new(params[:wow_character])
    #TODO need to add the CharacterProxy

    respond_to do |format|
      if @character.save
        format.html { redirect_to(@character, :notice => 'Character was successfully created.') }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wow_characters/1
  # PUT /wow_characters/1.xml
  def update
    @character = WowCharacter.find_by_id(params[:id])
    @game = Game.find_by_id(@character.game_id) if @character

    respond_to do |format|
      if @character.update_attributes(params[:wow_character])
        flash[:notice] = 'Character was successfully updated.'
        respond_with(@character)
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /wow_characters/1
  # DELETE /wow_characters/1.xml
  def destroy
    @character = WowCharacter.find_by_id(params[:id])
    @character.destroy if @character
    
    respond_to do |format|
      format.html { redirect_to user_profile_path(UserProfile.find_by_id(current_user)), :notice => 'Character deleted' }
      format.xml  { head :ok }
    end
  end
end
