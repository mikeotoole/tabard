###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for Minecraft characters.
###
class MinecraftCharactersController < ApplicationController
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
  # GET /minecraft_characters/new
  def new
  end

  # GET /minecraft_characters/:id/edit(.:format)
  def edit
  end

  # POST /minecraft_characters(.:format)
  def create
    begin
      @minecraft_character = MinecraftCharacter.create_character(params, current_user)
      add_new_flash_message("\"#{@minecraft_character.name}\" has been created.", 'success') if @minecraft_character.character_proxy and @minecraft_character.character_proxy.valid?
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @minecraft_character.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @minecraft_character.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with @minecraft_character, :location => user_profile_url(@minecraft_character.user_profile) + '#characters'
  end

  # PUT /minecraft_characters/:id(.:format)
  def update
    begin
      @minecraft_character = MinecraftCharacter.find(params[:id])
      authorize!(:update, @minecraft_character)
      add_new_flash_message("Details for \"#{@minecraft_character.name}\" have been saved.", 'success') if @minecraft_character.update_attributes(params[:minecraft_character])
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @minecraft_character.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @minecraft_character.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with @minecraft_character, :location => user_profile_url(@minecraft_character.user_profile) + '#characters'
  end

  # DELETE /minecraft_characters/:id(.:format)
  def destroy
    add_new_flash_message("\"#{@minecraft_character.name}\" has been removed.", 'notice') if @minecraft_character and @minecraft_character.destroy

    respond_with @minecraft_character, :location => user_profile_url(@minecraft_character.user_profile) + '#characters'
  end
end
