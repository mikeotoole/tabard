###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Star Wars the Old Republic characters.
###
class SwtorCharactersController < ApplicationController
  respond_to :html, :js
###
# Callbacks
###
  prepend_before_filter :authenticate_user!
  before_filter :find_swtor_character, :only => [:show, :edit, :update, :destroy]

###
# REST Actions
###
  ###
  # GET /games/:game_id/swtor_characters/:id(.:format)
  # GET /swtor_characters/:id(.:format)
  ###
  def show
    respond_with(@character)
  end

  # GET /games/:game_id/swtor_characters/new(.:format)
  def new
    @character = SwtorCharacter.new
    @character.game_id = params[:game_id]
    respond_with(@character)
  end

  # GET /games/:game_id/swtor_characters/:id/edit(.:format)
  def edit
  end

  # POST /games/:game_id/swtor_characters(.:format)
  def create
    @character = SwtorCharacter.new(params[:swtor_character])

    profile = current_user.user_profile
    profile.build_character(@character, params[:default])

    add_new_flash_message('Character was successfully created.') if profile.save
    respond_with(@character.game, @character)
  end

  # PUT /games/:game_id/swtor_characters/:id(.:format)
  def update
    if params[:default]
      @character.set_as_default
      #@character.character_proxy.user_profile.set_as_default_character(@character)
    end

    add_new_flash_message('Character was successfully updated.') if @character.update_attributes(params[:swtor_character])
    respond_with(@character.game, @character)
  end

  # DELETE /games/:game_id/swtor_characters/:id(.:format)
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

  # Find swtor character with given id.
  def find_swtor_character
    @character = SwtorCharacter.find_by_id(params[:id])
  end
end
