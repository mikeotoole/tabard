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
  prepend_before_filter :block_unauthorized_user!, :except => :show
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => :update

###
# REST Actions
###
  ###
  # GET /wow_characters/:id(.:format)
  ###
  def show
    respond_with(@wow_character)
  end

  # GET /wow_characters/:id/edit(.:format)
  def edit
  end

  # POST /wow_characters(.:format)
  def create
    @wow_character = WowCharacter.create(params[:wow_character])

    profile = current_user.user_profile
    proxy = profile.character_proxies.build(:character => @wow_character, :default_character => params[:default])

    add_new_flash_message('Character was successfully created.') if proxy.save
    respond_with(@wow_character)
  end

  # PUT /wow_characters/:id(.:format)
  def update
    @wow_character = WowCharacter.find(params[:id])
    authorize!(:update, @wow_character)

    add_new_flash_message('Character was successfully updated.') if @wow_character.update_attributes(params[:wow_character])
    respond_with(@wow_character)
  end

  # DELETE /wow_characters/:id(.:format)
  def destroy
    if @wow_character
      add_new_flash_message('Character was successfully deleted.') if @wow_character.destroy
    end
    respond_with(@wow_character)
  end
end
