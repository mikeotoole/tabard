class Management::GamesController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml   
   
   
  # GET /management/games
  # GET /management/games.xml
  def index
    if !current_user.can_show("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @games = Game.all
      respond_with(@games)
    end
  end

  # GET /management/games/new
  # GET /management/games/new.xml
  def new
    if !current_user.can_create("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @game = Game.new
      respond_with(@game)
    end
  end

  # GET /management/games/1/edit
  def edit
    if !current_user.can_update("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @game = Game.find(params[:id])
    end
  end

  # POST /management/games
  # POST /management/games.xml
  def create
    if !current_user.can_create("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @game = Game.new(params[:game])
  
      respond_to do |format|
        if @game.save
          format.html { redirect_to(management_games_path, :notice => 'Game was successfully created.') }
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
    if !current_user.can_update("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @game = Game.find(params[:id])
  
      respond_to do |format|
        if @game.update_attributes(params[:game])
          format.html { redirect_to(management_games_path, :notice => 'Game was successfully updated.') }
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
    if !current_user.can_delete("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @game = Game.find(params[:id])
      @game.destroy
  
      respond_to do |format|
        format.html { redirect_to(management_games_path) }
        format.xml  { head :ok }
      end
    end
  end
end
