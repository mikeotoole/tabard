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
  skip_before_filter :enforce_community_features, only: [:disabled]
  skip_before_filter :ensure_current_user_is_member, only: [:disabled]

  load_and_authorize_resource except: [:activities, :disabled]
  prepend_before_filter :block_unauthorized_user!, except: [:activities, :disabled]
  before_filter :load_activities, only: [:activities]

###
# REST Actions
###

  def disabled
    if current_community.is_disabled?
    else
      redirect_to root_url(subdomain: current_community.subdomain)
    end
  end

  # GET /community_settings(.:format)
  def edit
  end

  # PUT /community_settings(.:format)
  def update
    begin
      if @community.update_attributes(params[:community])
        @community.action_items.delete(:update_settings)
        @community.save
        flash[:success] = 'Your changes have been saved.'
      else
        flash[:alert] = 'Error. Unable to save changes.'
      end
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::Timeout, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @community.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @community.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with @community, location: edit_community_settings_url
  end

  # GET /activities(.:format)
  def activities
    raise CanCan::AccessDenied unless user_signed_in? and current_user.is_member? @community
    if params[:updated]
      render partial: "activities/activities", locals: { activities: @activities, community: @community }
    else
      render partial: 'subdomains/communities/activities', locals: { community: @community, activities: @activities, activities_count_initial: @activities_count_initial, activities_count_increment: @activities_count_increment }
    end
  end

  # GET /autocomplete-members(.:format)
  def autocomplete_members
    @user_profiles = current_community.member_profiles.search params[:term]
    @characters = current_community.approved_characters.search params[:term]
    view = params[:view]

    results =
      @user_profiles.map{|profile|
        hash = {
          label: "<a>#{view_context.image_tag(view_context.image_path(profile.avatar_url(:icon)))} <strong>#{profile.display_name}</strong></a>",
          value: profile.id,
          display_name: profile.display_name
        }
        case view
          when 'event-invites' then hash[:html] = render_to_string partial: 'subdomains/events/invite_fields', locals: { _i: '_INDEX_', user_profile: profile }
        end
        hash
      } +
      @characters.map{|character|
        hash = {
          label: "<a>#{view_context.image_tag(view_context.image_path(character.avatar_url(:icon)))} <strong>#{character.name}</strong> (#{character.user_profile_display_name})</a>",
          value: character.user_profile.id,
          display_name: character.user_profile_display_name
        }
        case view
          when 'event-invites' then hash[:html] = render_to_string partial: 'subdomains/events/invite_fields', locals: { _i: '_INDEX_', user_profile: character.user_profile, character: character }
        end
        hash
      }

    render json: results
  end

  # This clears the action items for the community
  def clear_action_items
    authorize! :update, @community
    @community.action_items = {}
    if @community.save
      success = true
      message = ''
    else
      success = false
      message = 'Unable to clear action items.'
    end
    respond_to do |format|
      format.html {
        flash[:alert] = message unless success
        redirect_to subdomain_home_url
      }
      format.js { render json: { success: success, message: message } }
    end
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
    @activities = Activity.activities({ community_id: @community.id }, updated, count).includes(:user_profile, :target, page: [:page_space], comment: [:character, :user_profile, :community, :original_commentable], discussion: [:discussion_space], community: [:member_role])
  end
end
