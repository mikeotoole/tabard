###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class ArtworkUploadsController < InheritedResources::Base
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, :except => [:new, :create]
  load_and_authorize_resource

###
# REST Actions
###
  # GET /artwork_uploads/new(.:format)
  def new
    @artwork_upload.document = ArtworkAgreement.current
  end
  
  # POST /artwork_uploads(.:format)
  def create
    if @artwork_upload.save
      add_new_flash_message("Your artwork has been uploaded. Thank You!",'success')
      redirect_to root_url
    else
      respond_with(@artwork_upload)
    end
  end
end
