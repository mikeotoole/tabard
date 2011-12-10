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
  # GET /wow_characters/new
  def new
  end

  # GET /wow_characters/:id/edit(.:format)
  def edit
  end

  # POST /wow_characters(.:format)
  def create
    @wow_character = WowCharacter.create_character(params, current_user)

    add_new_flash_message('Character was successfully created', 'success') if @wow_character.character_proxy and @wow_character.character_proxy.valid?

    respond_with @wow_character, :location => user_root_url + '#characters'
  end

  # PUT /wow_characters/:id(.:format)
  def update
    @wow_character = WowCharacter.find(params[:id])
    authorize!(:update, @wow_character)
    if params[:wow_character][:faction] or params[:wow_character][:server_name]
      @wow_character.wow = Wow.game_for_faction_server(params[:wow_character][:faction], params[:wow_character][:server_name])
    end
    add_new_flash_message('Character was successfully updated', 'success') if @wow_character.update_attributes(params[:wow_character])
    
    respond_with @wow_character, :location => user_root_url + '#characters'
  end

  # DELETE /wow_characters/:id(.:format)
  def destroy
    add_new_flash_message('Character was successfully removed') if @wow_character and @wow_character.destroy

    respond_with(@wow_character)
  end
end
