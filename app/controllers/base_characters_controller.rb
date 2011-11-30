###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is creating characters.
###
class BaseCharactersController < ApplicationController
  respond_to :html, :js
###
# Callbacks
###
  before_filter :block_unauthorized_user!

###
# REST Actions
###
  # GET /base_characters/new(.:format)
  def new
      @game = Game.find_by_id(params[:game][:game_id])
      if @game != nil
        case @game.type
          when "Swtor"
            respond_to do |format|
              format.html { redirect_to(new_swtor_character_path) }
              format.js { redirect_to(new_swtor_character_path(:format => :js)) }
            end
            return
          when "Wow"
            respond_to do |format|
              format.html { redirect_to(new_wow_character_path) }
              format.js { redirect_to(new_wow_character_path(:format => :js)) }
            end
            return
          else
            add_new_flash_message('Game not found.',"alert")
            logger.error("Character for game #{@game.to_yaml} could not be created. Game not in list.")
            redirect_to(:back)
            return
        end
      else
        add_new_flash_message('Please select a game.',"alert")
        redirect_to(:back)
      end
  end
end
