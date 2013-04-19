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
  before_filter :block_unauthorized_user!, except: [:show, :activities, :characters, :index]
  before_filter :set_current_user_as_profile, only: :account
  load_and_authorize_resource except: [:index, :activities, :characters, :announcements, :invites]
  skip_authorize_resource only: :account
  before_filter :find_user_by_id, only: [:characters, :activities, :announcements, :invites]
  before_filter :load_activities, only: [:show, :activities]
  before_filter :authorize_custom_actions, only: [:activites, :announcements, :characters, :invites]

  # GET /user_profiles/1(.:format)
  def show
    subdomain_community = Community.find_by_subdomain(params[:subdomain])
    if subdomain_community.blank?
      can_assign_roles = false
    else
      temp_ability = Ability.new(current_user)
      temp_ability.dynamicContextRules(current_user, subdomain_community)
      can_assign_roles = temp_ability.can? :accept, Role
    end
    respond_to do |format|
      format.html {
        if @user_profile.is_disabled?
          flash[:alert] = 'The profile you requested is no longer active.'
          render 'inactive_show'
        else
          @communities_to_invite_to = Array.new
          @communities_with_roles_to_assign = Array.new
          if user_signed_in?
            current_sponsor_id = current_user.user_profile_id
            @potential_communities_to_invite_to = (current_user.communities - (@user_profile.communities + @user_profile.community_invite_applications.where{sponsor_id == current_sponsor_id}.map{|i| i.community}))
            @potential_communities_to_invite_to.each do |community|
              temp_ability = Ability.new(current_user)
              temp_ability.dynamicContextRules(current_user, community)
              @communities_to_invite_to << community if temp_ability.can? :create, @user_profile.community_invite_applications.new({community: community, sponsor: current_user.user_profile}, without_protection: true)
            end
            @user_profile.roles.includes(:community).order(:community_id).group_by{|r| r.community }.each do |community, roles|
              temp_ability = Ability.new(current_user)
              temp_ability.dynamicContextRules(current_user, community)
              @communities_with_roles_to_assign << community if temp_ability.can? :accept, Role
            end
          end
        end
      }
      format.js {
        if @user_profile.is_disabled?
          render json: {success: false, text: 'This profile is no longer active.'}
        else
          render json: {
            success: true,
            can_assign_roles: can_assign_roles,
            html: render_to_string(partial: 'user_profiles/modal', locals: {user_profile: @user_profile}), userProfileId: @user_profile.id
          }
        end
      }
    end
  end

  # GET /user_profiles/1/edit(.:format)
  def edit
  end

  # PUT /user_profiles/1(.:format)
  def update
    begin
      @user_profile.update_attributes(params[:user_profile])
    rescue Excon::Errors::HTTPStatusError, Excon::Errors::SocketError, Excon::Errors::ProxyParseError, Excon::Errors::StubNotFound
      logger.error "ERROR controller=user_profiles action=update error=#{e.class} message=#{e.message}"
      @user_profile.errors.add :base, "An error has occurred while processing the image."
    rescue CarrierWave::UploadError, CarrierWave::DownloadError, CarrierWave::FormNotMultipart, CarrierWave::IntegrityError, CarrierWave::InvalidParameter, CarrierWave::ProcessingError
      logger.error "ERROR controller=user_profiles action=update error=#{e.class} message=#{e.message}"
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
    @invites = current_user.invites.fresh.order(:is_viewed).includes(:user_profile, :character, event: [:community]).page params[:page]
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
    @activities = Activity.activities({ user_profile_id: @user_profile.id }, updated, count).includes(:user_profile, :target, page: [:page_space], community_game: [:community, :game], community: [:member_role])
  end

  # Gets the user profile by ID
  def find_user_by_id
    @user_profile = UserProfile.find(params[:id]) unless !!@user_profile
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
