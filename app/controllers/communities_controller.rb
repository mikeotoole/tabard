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
  before_filter :block_unauthorized_user!, except: [:show, :index]
  skip_before_filter :ensure_not_ssl_mode, only: [:destroy]
  skip_before_filter :limit_subdomain_access, only: [:destroy]
  before_filter :ensure_secure_subdomain, only: [:destroy]
  load_and_authorize_resource except: [:create, :index]
  before_filter :load_plans, only: [:new, :create]

###
# REST Actions
###
  # GET /communities/:id(.:format)
  def show
    redirect_to root_url(subdomain: @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community.admin_profile = current_user.user_profile
    @community.community_plan = CommunityPlan.default_plan
  end

  # POST /communities(.:format)
  def create
    begin
      @stripe_card_token = params[:stripe_card_token]
      @community = Community.new(params[:community])
      @community.admin_profile = current_user.user_profile
      authorize! :create, @community
      if @community.is_paid_community?
        success = @community.update_attributes_with_payment(params[:community], @stripe_card_token)
      else
        success = @community.save
      end
      flash[:success] = "Your community has been created." if success
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::Timeout, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @community.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @community.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with(@community, location: edit_community_settings_url(subdomain: @community.subdomain))
  end

  # DELETE /communities/:id(.:format)
  def destroy
    if params[:user] and current_user.valid_password?(params[:user][:current_password])
      Community.delay.destory_community(@community.id)
      @community.update_column(:pending_removal, true)
      flash[:notice] = 'Community is being removed.'
      redirect_to user_profile_url(current_user.user_profile, subdomain: false, protocol: "http://")
    else
      flash[:alert] = 'Password was not valid.'
      redirect_to community_remove_confirmation_url(subdomain: @community.subdomain)
    end
  end

protected

  # Loads all available plans.
  def load_plans
    @available_plans = CommunityPlan.available
  end

###
# Helper methods
###
  helper_method :sort_column
private
  def sort_column
    Community.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
end
