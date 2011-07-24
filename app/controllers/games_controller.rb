class GamesController < ApplicationController
  respond_to :html

  def show
    @game = Game.active.find(params[:id])
    respond_with(@game)
  end
end