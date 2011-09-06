###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for World of Warcraft characters.
###
class WowCharactersController < ApplicationController
  respond_to :html, :js
###
# Before Filters
###
  prepend_before_filter :authenticate_user! #TODO Joe, is this right?
  before_filter :find_swtor_character, :only => [:show, :edit, :update, :destroy]

###
# REST Actions
###
  ###
  # GET /games/:game_id/wow_characters/:id(.:format)
  # GET /wow_characters/:id(.:format)
  ###
  def show
    respond_with(@character)
  end

  # GET /games/:game_id/wow_characters/new(.:format)
  def new
    @character = WowCharacter.new
    @character.game_id = params[:game_id]
    respond_with(@character)
  end

  # GET /games/:game_id/wow_characters/:id/edit(.:format)
  def edit
  end

  # POST /games/:game_id/wow_characters(.:format)
  def create
    @character = WowCharacter.new(params[:wow_character])

    profile = current_user.user_profile
    profile.build_character(@character, params[:default])

    add_new_flash_message('Character was successfully created.') if profile.save
    respond_with(@character.game, @character)
  end

  # PUT /games/:game_id/wow_characters/:id(.:format)
  def update
    if params[:default]
      # OPTIMISE Joe, make this better.
      @character.character_proxy.user_profile.set_as_default_character(@character)
    end

    add_new_flash_message('Character was successfully updated.') if @character.update_attributes(params[:wow_character])
    respond_with(@game, @character)
  end

  # DELETE /games/:game_id/wow_characters/:id(.:format)
  def destroy
    if @character
      add_new_flash_message('Character was successfully deleted.') if @character.destroy
    end
    respond_with(@character)
  end

###
# Protected Methods
###
protected

  # Find wow character with given id.
  def find_wow_character
    @character = WowCharacter.find_by_id(params[:id])
  end
end
