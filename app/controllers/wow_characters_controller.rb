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
  prepend_before_filter :authenticate_user!, :except => :show
  load_and_authorize_resource
  skip_load_and_authorize_resource :only => :update

###
# REST Actions
###
  # GET /wow_characters/:id(.:format)
  def show
    respond_with(@wow_character)
  end

  # GET /wow_characters/new
  def new
  end

  # GET /wow_characters/:id/edit(.:format)
  def edit
  end

  # POST /wow_characters(.:format)
  def create
    wow = Wow.game_for_faction_server(params[:wow_character][:faction], params[:wow_character][:server_name])
    params[:wow_character][:wow_id] = wow.id if wow
    @wow_character = WowCharacter.create(params[:wow_character])

    if @wow_character.valid?
      profile = current_user.user_profile
      proxy = profile.character_proxies.build(:character => @wow_character, :default_character => params[:wow_character][:default])
      add_new_flash_message('Character was successfully created.') if proxy.save
    else
      @wow_character.wow = Wow.new(:faction => params[:wow_character][:faction], :server_name => params[:wow_character][:server_name])
      @wow_character.errors.add(:server_name, "can't be blank") if not params[:wow_character][:server_name]
      @wow_character.errors.add(:faction, "can't be blank") if not params[:wow_character][:faction]
    end

    respond_with(@wow_character)
  end

  # PUT /wow_characters/:id(.:format)
  def update
    @wow_character = WowCharacter.find(params[:id])
    authorize!(:update, @wow_character)

    wow = Wow.game_for_faction_server(params[:wow_character][:faction], params[:wow_character][:server_name])
    @wow_character.wow = wow if wow
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
