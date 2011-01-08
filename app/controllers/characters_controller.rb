class CharactersController < ApplicationController
  # GET /characters/1/edit
  def edit
    @character = Character.find(params[:id])
  end

  # POST /games/game_id/characters
  # POST /games/game_id/characters.xml
  def create
    @game = Game.find(params[:game_id])
    @character = @game.characters.factory(@game.type, @game.id, params[:character])

    respond_to do |format|
      if @character.save
        @profile = Profile.find(@character.game_profile_id)
        format.html { redirect_to(@profile, :notice => 'Character was successfully created.') }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { redirect_to @profile, :alert => 'Unable to add character' }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/game_id/characters/1
  # PUT /games/game_id/characters/1.xml
  def update
    @game = Game.find(params[:game_id])
    @character = Character.find(params[:id])

    respond_to do |format|
      if @character.update_attributes(params[:character])
        format.html { redirect_to(@game, :notice => 'Character was successfully updated.') }
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
    @game = Game.find(params[:game_id])
    @character = Character.find(params[:id])
    @character.destroy
    
    respond_to do |format|
      format.html { redirect_to @game, :notice => 'Character deleted' }
      format.xml  { head :ok }
    end
  end
end
