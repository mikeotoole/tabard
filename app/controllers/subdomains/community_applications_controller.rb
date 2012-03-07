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
  before_filter :block_unauthorized_user!
  before_filter :load_application, :except => [:new, :create]
  before_filter :create_application, :only => [:new, :create]
  before_filter :ensure_current_user_is_member, :only => [:index]
  authorize_resource :except => [:index]
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
    @supported_games = current_community.supported_games
    @comments = @community_application.comments.page params[:page]
  end

  # GET /community_applications/new
  # GET /community_applications/new.json
  def new
    if current_user.is_member? current_community
      add_new_flash_message "You are already a member of this community.", 'notice'
      redirect_to my_roster_assignments_path
    elsif current_user.application_pending? current_community
      add_new_flash_message "You have already applied to this community. Your application is pending review.", 'notice'
      redirect_to root_url(:subdomain => current_community.subdomain)
    else
      @community_application.submission.custom_form.questions.each do |question|
        @community_application.submission.answers.new :question_body => question.body, :question_id => question.id
      end
    end
  end

  # POST /community_applications
  # POST /community_applications.json
  def create
    if @community_application.save
      add_new_flash_message @community_application.custom_form_thankyou, 'success'
    end
    respond_with @community_application, :location => custom_form_thankyou_url(@community_application.custom_form), :error_behavior => :list
  end

  # DELETE /community_applications/1
  # DELETE /community_applications/1.json
  def destroy
    if @community_application.withdraw
      add_new_flash_message 'Your application has been withdrawn.', 'notice'
    end
    respond_with @community_application
  end

  # This accepts the specified application.
  def accept
    params[:proxy_hash] ||= Hash.new
    @community_application.accept_application(current_user.user_profile, params[:proxy_hash])
    redirect_to community_application_url(@community_application)
  end

  # This rejects the specified application.
  def reject
    @community_application.reject_application(current_user.user_profile)
    redirect_to community_application_url(@community_application)
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

  ###
  # _before_filter
  #
  # This before filter attempts to create @community_application from: community_applications.new(params[:community_application]) or community_applications.new(), for the current community.
  ###
  def create_application
    if(params[:community_application])
      params[:community_application][:character_proxy_ids] ||= []
    end
    @community_application = current_community.community_applications.new(params[:community_application])
    @community_application.user_profile = current_user.user_profile
    @community_application.submission ||= Submission.new(:custom_form => current_community.community_application_form, :user_profile => current_user.user_profile)
    @community_application.submission.custom_form = current_community.community_application_form
    @community_application.submission.user_profile = current_user.user_profile
  end
end
