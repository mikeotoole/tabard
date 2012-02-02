###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for user profiles.
###
class UserProfilesController < ApplicationController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, :except => [:show]
  before_filter :set_current_user_as_profile, :only => [:dashboard, :account]
  load_and_authorize_resource
  skip_authorize_resource :only => :account
  before_filter :load_activities, :only => [:dashboard, :show]

  # GET /dashboard
  def dashboard
    render :show
  end

  # GET /user_profiles/1
  def show
    if @user_profile.is_disabled?
      add_new_flash_message 'The user profile you requested has been disabled.', 'alert'
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

  # This method sets the user_profile to the current_user.user_profile
  def set_current_user_as_profile
    @user_profile = current_user.user_profile
    authorize! :update, @user_profile
  end

  # This method gets a list of activites for the user profile
  def load_activities
    @activities_count_initial = 20
    @activities_count_increment = 10
    @activities = Activity.activities({ user_profile_id: @user_profile.id }, nil, @activities_count_initial)
  end

end
