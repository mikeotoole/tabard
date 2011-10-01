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
  before_filter :authenticate_user!, :except => [:show]
  before_filter :set_current_user_as_profile, :only => [:index, :account]
  load_and_authorize_resource
  skip_authorize_resource :only => :account

  # GET /user_profiles/
  def index
    render :show
  end

  # GET /user_profiles/1
  def show

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
