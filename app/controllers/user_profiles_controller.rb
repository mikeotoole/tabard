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
  before_filter :block_unauthorized_user!, :except => [:show, :activities, :characters]
  before_filter :set_current_user_as_profile, :only => [:dashboard, :account]
  load_and_authorize_resource :except => [:activities, :characters]
  skip_authorize_resource :only => :account
  before_filter :load_activities, :only => [:dashboard, :show, :activities, :characters]

  # GET /dashboard
  def dashboard
    render :show
  end

  # GET /user_profiles/1
  def show
    if @user_profile.is_disabled?
      add_new_flash_message 'The user profile you requested is no longer active.', 'alert'
      redirect_to root_url
    end
  end

  # GET /user_profiles/1/edit
  def edit
  end

  # PUT /user_profiles/1
  def update
    @user_profile.update_attributes(params[:user_profile])
    respond_with(@user_profile)
  end

  # GET /account(.:format)
  def account
    render :edit
  end

  # GET /user_profiles/:id/activities(.:format)
  def activities
    render :partial => 'user_profiles/activities', :locals => { :user_profile => @user_profile, :activities => @activities, :activities_count_initial => @activities_count_initial, :activities_count_increment => @activities_count_increment }
  end

  # GET /user_profiles/:id/characters(.:format)
  def characters
    render :partial => 'user_profiles/characters', :locals => { :user_profile => @user_profile }
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
    @user_profile = UserProfile.find_by_id(params[:id])
    @activities_count_initial = 20
    @activities_count_increment = 10
    @activities = Activity.activities({ user_profile_id: @user_profile.id }, nil, @activities_count_initial)
  end

end