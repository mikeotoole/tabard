class BaseCharactersController < ApplicationController
  before_filter :authenticate, :except => [:new]
  respond_to :html, :xml, :js
  
  # GET /base_characters/new
  def new
      @game = Game.find_by_id(params[:game][:game_id])
      if @game != nil
        case @game.type
          when "Swtor"
            respond_to do |format|
              format.html { redirect_to(new_game_swtor_character_path(@game)) }
              format.js { redirect_to(new_game_swtor_character_path(@game, :format => :js)) }
            end
            return
          when "Wow"
            respond_to do |format|
              format.html { redirect_to(new_game_wow_character_path(@game)) }
              format.js { redirect_to(new_game_wow_character_path(@game, :format => :js)) }
            end
            return
          else
            redirect_to(:back, :alert => 'Game not found.')
            return
        end
      else
        redirect_to(:back, :alert => 'Please select a game.')
      end  
  end
end