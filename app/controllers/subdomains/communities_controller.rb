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
    if @community.update_attributes(params[:community])
      add_new_flash_message 'Your changes have been saved.', 'success'
    else
      add_new_flash_message 'Error. Unable to save changes.', 'alert'
    end
    respond_with(@community, :location => edit_community_settings_url)
  end
  
  def remove_confirmation
  end
end
