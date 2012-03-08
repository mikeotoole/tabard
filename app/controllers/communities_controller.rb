###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class CommunitiesController < ApplicationController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, :except => [:show, :index]
  skip_before_filter :ensure_not_ssl_mode, :only => [:destroy]
  skip_before_filter :limit_subdomain_access, :only => [:destroy]
  before_filter :ensure_secure_subdomain, :only => [:destroy]
  load_and_authorize_resource :except => [:create, :index]

###
# REST Actions
###
  # GET /communities(.:format)
  def index
    @communities = Community.order(:name).page params[:page]
  end

  # GET /communities/:id(.:format)
  def show
    redirect_to root_url(:subdomain => @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community.admin_profile = current_user.user_profile
  end

  # POST /communities(.:format)
  def create
    begin
      @community = Community.new(params[:community])
      @community.admin_profile = current_user.user_profile
      authorize! :create, @community
      add_new_flash_message("Your community has been created.", 'success') if @community.save
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::Timeout, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @community.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @community.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with(@community, location: supported_games_url(:subdomain => @community.subdomain))
  end
  
  # DELETE /communities/:id(.:format)
  def destroy
    if params[:user] and current_user.valid_password?(params[:user][:current_password])
      Community.delay.destory_community(@community.id)
      @community.update_attribute(:pending_removal, true)
      add_new_flash_message 'Community is being removed.', 'notice'
      redirect_to user_root_url(:subdomain => false)
    else
      add_new_flash_message 'Password was not valid.', 'alert'
      redirect_to community_remove_confirmation_url(:subdomain => @community.subdomain)
    end
  end
end
