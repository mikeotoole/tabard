class BaseCharactersController < ApplicationController
  before_filter :authenticate
  respond_to :html, :xml, :js
  
  # GET /base_characters/new
  def new
      @game = Game.find_by_id(params[:game][:game_id])
      if @game != nil
        case @game.type
          when "Swtor"
            redirect_to(new_swtor_character_path(@game))
            return
          when "Wow"
            redirect_to(new_wow_character_path(@game))
            return
        end
      else
        redirect_to(:back)
      end  
  end
end
