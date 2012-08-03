###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class UserProfilesController < ApplicationController
  respond_to :html, :js
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, except: [:show, :activities, :characters, :announcements, :invites, :index]
  before_filter :set_current_user_as_profile, only: :account
  load_and_authorize_resource except: [:index, :activities, :characters, :announcements, :invites]
  skip_authorize_resource only: :account
  before_filter :find_user_by_id, only: [:characters, :activities, :announcements, :invites]
  before_filter :load_activities, only: [:show, :activities]
  before_filter :authorize_custom_actions, only: [:activites, :announcements, :characters, :invites]

  # GET /user_profiles/
  def index
    authorize! :index, UserProfile
    @user_profiles = UserProfile.active.search(params[:search]).order(sort_column + " IS NULL, LOWER(#{sort_column}) #{sort_direction}").page params[:page]
  end

  # GET /user_profiles/1
  def show
    if @user_profile.is_disabled?
      add_new_flash_message 'The user profile you requested is no longer active.', 'alert'
      redirect_to root_url(subdomain: false)
    end
    if user_signed_in?
      @potential_communitys_to_invite_to = (current_user.communities - @user_profile.communities)
      @communitys_to_invite_to = Array.new
      @potential_communitys_to_invite_to.each do |community|
        temp_ability = Ability.new(current_user)
        temp_ability.dynamicContextRules(current_user, community)
        @communitys_to_invite_to << community if temp_ability.can? :create, @user_profile.community_invite_applications.new({community: community, sponsor: current_user.user_profile}, without_protection: true)
      end
    else
      @communitys_to_invite_to = nil
    end

  end

  # GET /user_profiles/1/edit
  def edit
  end

  # PUT /user_profiles/1
  def update
    begin
      @user_profile.update_attributes(params[:user_profile])
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "#{$!}"
      @user_profile.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "#{$!}"
      @user_profile.errors.add :base, "Unable to upload your artwork due to an image uploading error."
    end
    respond_with(@user_profile)
  end

  # GET /account(.:format)
  def account
    render :edit
  end

  # GET /user_profiles/:id/activities(.:format)
  def activities
    unless params[:updated]
      render partial: 'user_profiles/activities', locals: { user_profile: @user_profile, activities: @activities, activities_count_initial: @activities_count_initial, activities_count_increment: @activities_count_increment }
    else
      render partial: "activities/activities", locals: { activities: @activities, user_profile: @user_profile }
    end
  end

  # GET /user_profiles/:id/activities(.:format)
  def announcements
    @acknowledgements = current_user.acknowledgements.includes(announcement: [:community]).order(:has_been_viewed).ordered.page params[:page]
    render partial: 'user_profiles/announcements', locals: { acknowledgements: @acknowledgements }
  end

  # GET /user_profiles/:id/characters(.:format)
  def characters
    render partial: 'user_profiles/characters', locals: { user_profile: @user_profile }
  end

  # GET /user_profiles/:id/invites(.:format)
  def invites
    @invites = current_user.invites.fresh.order(:is_viewed).includes(:user_profile, :character_proxy, event: [:community]).page params[:page]
    render partial: 'user_profiles/invites', locals: { invites: @invites }
  end

###
# Callback Methods
###
  # This method sets the user_profile to the current_user.user_profile
  def set_current_user_as_profile
    @user_profile = current_user.user_profile
    authorize! :update, @user_profile
  end

  # This method gets a list of activites for the user profile
  def load_activities
    @activities_count_initial = 20
    @activities_count_increment = 10
    updated = !!params[:updated] ? params[:updated] : nil
    count = !!params[:max_items] ? params[:max_items] : @activities_count_initial
    @activities = Activity.activities({ user_profile_id: @user_profile.id }, updated, count).includes(:user_profile, :target, community: [:member_role])
  end

  # Gets teh user profile
  def find_user_by_id
    @user_profile = UserProfile.find_by_id(params[:id]) unless !!@user_profile
  end

  #Authorizes the custom actions
  def authorize_custom_actions
    raise CanCan::AccessDenied if not @user_profile.publicly_viewable and !!current_user and not @user_profile.id == current_user.user_profile_id
  end

###
# Helper methods
###
  helper_method :sort_column
private
  def sort_column
    UserProfile.column_names.include?(params[:sort]) ? params[:sort] : "display_name"
  end
end