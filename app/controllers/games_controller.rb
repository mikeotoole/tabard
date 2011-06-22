class GamesController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml  
  
  # GET /games
  # GET /games.xml
  def index
    if !current_user.can_show("Game") 
      render_insufficient_privileges
    else 
      @games = Game.all 
      respond_with(@games)
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])
    if !current_user.can_show(@game) 
      render_insufficient_privileges
    else 
      respond_with(@game)
    end
  end
  
  # GET /management/games/new
  # GET /management/games/new.xml
  def new
    @game = Game.new
    if !current_user.can_create("Game") 
      render_insufficient_privileges
    else 
      respond_with(@game)
    end
  end

  # GET /management/games/1/edit
  def edit
    @game = Game.find(params[:id])
    if !current_user.can_update(@game) 
      render_insufficient_privileges
    end
  end

  # POST /management/games
  # POST /management/games.xml
  def create
    @game = Game.new(params[:game])
    if !current_user.can_create(@game) 
      render_insufficient_privileges
    else 
      @game = Game.new(params[:game])
  
      respond_to do |format|
        if @game.save
          add_new_flash_message('Game was successfully created.')
          format.html { redirect_to(games_path) }
          format.xml  { render :xml => @game, :status => :created, :location => @game }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /management/games/1
  # PUT /management/games/1.xml
  def update
    @game = Game.find(params[:id])
    if !current_user.can_update(@game) 
      render_insufficient_privileges
    else 
  
      respond_to do |format|
        if @game.update_attributes(params[:game])
          add_new_flash_message('Game was successfully updated.')
          format.html { redirect_to(games_path) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /management/games/1
  # DELETE /management/games/1.xml
  def destroy
    @game = Game.find(params[:id])
    if !current_user.can_delete(@game) 
      render_insufficient_privileges
    else 
      @game.destroy
  
      respond_to do |format|
        format.html { redirect_to(management_games_path) }
        format.xml  { head :ok }
      end
    end
  end
end