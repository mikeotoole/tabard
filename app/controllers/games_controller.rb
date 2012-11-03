class GamesController < ApplicationController
  skip_before_filter :block_unauthorized_user!
  def index
    @games = Game.all
  end

  def show
    @games = Game.all
  end

  def autocomplete
    @games = Game.search(params[:term]).pluck(:name)
    render json: @games
  end
end
