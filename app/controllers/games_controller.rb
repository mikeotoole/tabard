class GamesController < ApplicationController
  skip_before_filter :block_unauthorized_user!
  def index
    @games = Game.all
  end

  def show
    @games = Game.all
  end

  def autocomplete
    game_name = "%#{params[:term]}%"
    @games = Game.where{name =~ game_name}
    render json: @games.map(&:name)
  end
end
