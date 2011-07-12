class GamesController < ApplicationController
  respond_to :html, :xml  
  
  # GET /games
  # GET /games.xml
  def index
    @games = Game.active 
    respond_with(@games)
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.active.find(params[:id])
    respond_with(@game)
  end
end