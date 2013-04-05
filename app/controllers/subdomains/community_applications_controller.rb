###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for roles.
###
class Subdomains::CommunityApplicationsController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  before_filter :pitch_to_new_user, only: [:new]
  before_filter :block_unauthorized_user!
  before_filter :load_application, except: [:new, :create]
  before_filter :create_application, only: [:new, :create]
  before_filter :ensure_current_user_is_member, only: [:index]
  authorize_resource except: [:index]
  skip_before_filter :limit_subdomain_access

  # GET /community_applications
  # GET /community_applications.json
  def index
    authorize! :index, CommunityApplication
    @pending_community_applications = @community_applications.where{status == "Pending"}.order{ created_at.desc }.page params[:pending_page]
    @other_community_applications = @community_applications.includes(:user_profile).where{status != "Pending"}.order('user_profiles.display_name').page params[:other_page]
    respond_with @community_applications
  end

  # GET /community_applications/1
  # GET /community_applications/1.json
  def show
    flash[:alert].now = "Your community is full and you will not be able to accept any more members." if current_community.is_at_max_capacity? and can? :edit, current_community
    flash[:notice].now = "Your community is almost full. You will not be able to accept any more members if you are full." if current_community.is_at_almost_max_capacity? and can? :edit, current_community
    @community_games = current_community.community_games
    @comments = @community_application.comments.page params[:page]
    params[:character_hash] ||= Hash.new
    @community_application.characters.each do |character|
      community_games_for_character = @community_games.where(game_id: character.game_id).limit(2).pluck(:id)
      if community_games_for_character.size == 1
        params[:character_hash][character.id.to_s] = community_games_for_character.first
      end
    end
  end

  # GET /community_applications/new
  # GET /community_applications/new.json
  def new
    if current_user.is_member? current_community
      flash[:notice].now = "You are already a member of this community."
      redirect_to my_roster_assignments_path
    elsif current_user.application_pending? current_community
      flash[:notice].now = "You have already applied to this community. Your application is pending review."
      redirect_to root_url(subdomain: current_community.subdomain)
    else
      @community_application.submission.custom_form.questions.each do |question|
        @community_application.submission.answers.new question_body: question.body, question_id: question.id
      end
    end
  end

  # POST /community_applications
  # POST /community_applications.json
  def create
    if @community_application.save
      flash.now[:success] = @community_application.custom_form_thankyou
    end
    respond_with @community_application, location: custom_form_thankyou_url(@community_application.custom_form), error_behavior: :list
  end

  # DELETE /community_applications/1
  # DELETE /community_applications/1.json
  def destroy
    if @community_application.withdraw
      flash.now[:notice] = 'Your application has been withdrawn.'
    end
    respond_with @community_application
  end

  # This accepts the specified application.
  def accept
    params[:character_hash] ||= Hash.new
    if @community_application.user_profile.is_disabled?
      flash[:alert].now = "The application was unable to be accepted because the user has disabled their account."
      @community_games = current_community.community_games
      @comments = @community_application.comments.page params[:page]
      render :show
    else
      if @community_application.accept_application(current_user.user_profile, params[:character_hash])
        flash[:success].now = "The application to \"#{@community_application.community_name}\" has been accepted."
        redirect_to community_applications_url
      else
        flash[:alert].now = "The application was unable to be accepted because your community is full." if current_community.is_at_max_capacity?
        @community_games = current_community.community_games
        @comments = @community_application.comments.page params[:page]
        render :show
      end
    end
  end

  # This rejects the specified application.
  def reject
    flash[:notice].now = 'The application has been rejected.' if @community_application.reject_application(current_user.user_profile)
    redirect_to community_applications_url
  end
###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This before filter attempts to populate @community_applications and @community_application from the current_community.
  ###
  def load_application
    @community_applications = current_community.community_applications
    @community_application = current_community.community_applications.find_by_id(params[:id])
  end

  # This pitches to the new user.
  def pitch_to_new_user
    redirect_to new_user_registration_url(subdomain: "secure", community_id: current_community.id) and return false unless user_signed_in?
  end

  ###
  # _before_filter
  #
  # This before filter attempts to create @community_application from: community_applications.new(params[:community_application]) or community_applications.new(), for the current community.
  ###
  def create_application
    if(params[:community_application])
      params[:community_application][:character_ids] ||= []
    end
    @community_application = current_community.community_applications.new(params[:community_application])
    @community_application.user_profile = current_user.user_profile
    @community_application.submission ||= Submission.new(custom_form: current_community.community_application_form, user_profile: current_user.user_profile)
    @community_application.submission.custom_form = current_community.community_application_form
    @community_application.submission.user_profile = current_user.user_profile
  end
end
