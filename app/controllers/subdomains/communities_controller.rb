###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class Subdomains::CommunitiesController < SubdomainsController
  respond_to :html
  ###
  # Before Filters
  ###
  load_and_authorize_resource

###
# REST Actions
###
  # GET /community_settings(.:format)
  def edit
  end

  # PUT /community_settings(.:format)
  def update
    begin
      if @community.update_attributes(params[:community])
		    @community.action_items.delete(:update_settings)
      	@community.save
        add_new_flash_message 'Your changes have been saved.', 'success'
      else
        add_new_flash_message 'Error. Unable to save changes.', 'alert'
      end
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::Timeout, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @community.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @community.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with @community, :location => edit_community_settings_url
  end
  
  def clear_action_items
    @community.action_items = {}
    @community.save
    redirect_to subdomain_home_url
  end
  
  # Removes confirmations
  def remove_confirmation
  end
end