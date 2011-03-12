class SwtorCharactersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml, :js
    
  def index
    @characters = SwtorCharacter.all
  end
  
  # GET /swtor_characters/1/edit
  def edit
    @character = SwtorCharacter.find_by_id(params[:id])
  end
  
  # GET /swtor_characters/1
  # GET /swtor_characters/1.xml
  def show
      @character = SwtorCharacter.find_by_id(params[:id])
      @game = Game.find_by_id(@character.game_id) if @character
  
      respond_with(@character)
  end
  
  # GET /swtor_characters/new
  # GET /swtor_characters/new.xml
  def new
      @character = SwtorCharacter.new
      @character.game_id = params[:game_id]
  
      respond_with(@character)
  end

  # POST /swtor_characters
  # POST /swtor_characters.xml
  def create
    @character = SwtorCharacter.new(params[:swtor_character])
    #TODO need to add the CharacterProxy

    respond_to do |format|
      if @character.save
        format.html { redirect_to(game_character_path(@game, @character), :notice => 'Character was successfully created.') }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /swtor_characters/1
  # PUT /swtor_characters/1.xml
  def update
    @character = SwtorCharacter.find_by_id(params[:id])
    @game = Game.find_by_id(@character.game_id) if @character

    respond_to do |format|
      if @character.update_attributes(params[:swtor_character])
        flash[:notice] = 'Character was successfully updated.'
        respond_with(@character)
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /swtor_characters/1
  # DELETE /swtor_characters/1.xml
  def destroy
    @character = SwtorCharacter.find_by_id(params[:id])
    @character.destroy if @character
    
    respond_to do |format|
      format.html { redirect_to user_profile_path(UserProfile.find(current_user)), :notice => 'Character deleted' }
      format.xml  { head :ok }
    end
  end
end
