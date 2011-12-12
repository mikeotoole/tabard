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
  before_filter :set_current_user_as_profile, :only => [:index, :account]
  load_and_authorize_resource
  skip_authorize_resource :only => :account

  # GET /dashboard
  def dashboard
    @user_profile = current_user.user_profile
    @activities = Activity.activities
    render :show
  end

  # GET /user_profiles/1
  def show
    #@activities = Activity.activities
    @activities = Activity.activities({ :user_profile_id => @user_profile.id })
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

end
