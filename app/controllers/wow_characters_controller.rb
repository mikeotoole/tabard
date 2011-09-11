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
  prepend_before_filter :authenticate_user!
  before_filter :find_wow_character, :only => [:show, :edit, :update, :destroy]

###
# REST Actions
###
  ###
  # GET /wow_characters/:id(.:format)
  ###
  def show
    respond_with(@character)
  end

  # GET /wow_characters/:id/edit(.:format)
  def edit
  end

  # GET /wow_characters/new(.:format)
  def new
    @character = WowCharacter.new
    @character.game_id = params[:game_id]

    respond_with(@character)
  end

  # POST /wow_characters(.:format)
  def create
    @character = WowCharacter.create(params[:wow_character])

    profile = current_user.user_profile
    proxy = profile.character_proxies.build(:character => @character, :default_character => params[:default])

    add_new_flash_message('Character was successfully created.') if proxy.save
    respond_with(@character)
  end

  # PUT /wow_characters/:id(.:format)
  def update
    if params[:default]
      @character.set_as_default
    end

    add_new_flash_message('Character was successfully updated.') if @character.update_attributes(params[:wow_character])
    respond_with(@character)
  end

  # DELETE /wow_characters/:id(.:format)
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
