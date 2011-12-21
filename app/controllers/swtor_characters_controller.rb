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
  prepend_before_filter :block_unauthorized_user!, :except => :show
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => :update

###
# REST Actions
###
  # GET /swtor_characters/new
  def new
  end

  # GET /swtor_characters/:id/edit(.:format)
  def edit
  end

  # POST /swtor_characters(.:format)
  def create
    @swtor_character = SwtorCharacter.create_character(params, current_user)
    add_new_flash_message('Character was successfully created','success') if @swtor_character.character_proxy and @swtor_character.character_proxy.valid?

    respond_with @swtor_character, :location => user_root_url + '#characters'
  end

  # PUT /swtor_characters/:id(.:format)
  def update
    @swtor_character = SwtorCharacter.find(params[:id])
    authorize!(:update, @swtor_character)

    if params[:swtor_character] and (params[:swtor_character][:advanced_class] or params[:swtor_character][:server_name])
      @swtor_character.swtor = Swtor.game_for_faction_server(SwtorCharacter.faction(params[:swtor_character][:advanced_class]), params[:swtor_character][:server_name])
    end
    params[:swtor_character][:char_class] = SwtorCharacter.char_class(params[:swtor_character][:advanced_class]) if params[:swtor_character][:advanced_class]
    add_new_flash_message('Character was successfully updated.','success') if @swtor_character.update_attributes(params[:swtor_character])

    respond_with @swtor_character, :location => user_root_url + '#characters'
  end

  # DELETE /swtor_characters/:id(.:format)
  def destroy
    add_new_flash_message('Character was successfully removed.') if @swtor_character and @swtor_character.destroy

    respond_with(@swtor_character)
  end
end
