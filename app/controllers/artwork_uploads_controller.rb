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
  before_filter :block_unauthorized_user!, except: [:new, :create]
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
    begin
      flash[:success] = "Your artwork has been uploaded. Thank You!" if @artwork_upload.save
      respond_with(@artwork_upload, location: root_url)
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "ERROR Excon artwork_uploads update: #{$!}"
      @artwork_upload.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "ERROR CarrierWave artwork_uploads update: #{$!}"
      params[:artwork_upload][:remote_artwork_image_url] = ""
      @artwork_upload = ArtworkUpload.new(params[:artwork_upload])
      flash[:alert] = "Unable to upload your artwork due to an image uploading error."
      render :new
      return
    end
  end
end
