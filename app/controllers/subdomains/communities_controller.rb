###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class Subdomains::CommunitiesController < SubdomainsController
  respond_to :html, :js
  ###
  # Before Filters
  ###
  load_and_authorize_resource :except => [:activities]
  prepend_before_filter :block_unauthorized_user!, :except => [:activities]
  before_filter :load_activities, :only => [:activities]

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

  # GET /activities(.:format)
  def activities
    raise CanCan::AccessDenied unless user_signed_in? and current_user.is_member? @community
    unless params[:updated]
      render :partial => 'subdomains/communities/activities', :locals => { :community => @community, :activities => @activities, :activities_count_initial => @activities_count_initial, :activities_count_increment => @activities_count_increment }
    else
      render :partial => "activities/activities", :locals => { :activities => @activities, :community => @community }
    end
  end
  
  # This clears the action items for the community
  def clear_action_items
    @community.action_items = {}
    @community.save
    redirect_to subdomain_home_url
  end
  
  # Removes confirmations
  def remove_confirmation
  end

###
# Callback Methods
###
  # This method gets a list of activites for the community
  def load_activities
    @activities_count_initial = 20
    @activities_count_increment = 10
    updated = !!params[:updated] ? params[:updated] : nil
    count = !!params[:max_items] ? params[:max_items] : @activities_count_initial
    @activities = Activity.activities({ community_id: @community.id }, updated, count)
  end
end