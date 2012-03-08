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
    begin
      @wow_character = WowCharacter.create_character(params, current_user)
      add_new_flash_message("\"#{@wow_character.name}\" has been created.", 'success') if @wow_character.character_proxy and @wow_character.character_proxy.valid?
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::Timeout, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @wow_character.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @wow_character.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with @wow_character, :location => user_root_url + '#characters'
  end

  # PUT /wow_characters/:id(.:format)
  def update
    begin
      @wow_character = WowCharacter.find(params[:id])
      authorize!(:update, @wow_character)

      if params[:wow_character] and (params[:faction] or params[:server_name])
        @wow_character.wow = Wow.game_for_faction_server(params[:faction], params[:server_name])
      end
      add_new_flash_message("Details for \"#{@wow_character.name}\" have been saved.", 'success') if @wow_character.update_attributes(params[:wow_character])
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::Timeout, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @wow_character.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @wow_character.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with @wow_character, :location => user_root_url + '#characters'
  end

  # DELETE /wow_characters/:id(.:format)
  def destroy
    add_new_flash_message("\"#{@wow_character.name}\" has been removed.", 'notice') if @wow_character and @wow_character.destroy

    respond_with @wow_character, :location => user_profile_url(@wow_character.user_profile) + '#characters'
  end
end
