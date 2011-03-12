class GamesController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml  
  
  # GET /games
  # GET /games.xml
  def index
    if !current_user.can_show("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @games = Game.all 
      respond_with(@games)
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    if !current_user.can_show("Game") 
      render :nothing => true, :status => :forbidden
    else 
      @game = Game.find(params[:id])
      respond_with(@game)
    end
  end
end