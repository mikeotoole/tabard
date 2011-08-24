=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source

  This controller is for profiles.
=end
class ProfilesController < ApplicationController
  respond_to :html
  before_filter :authenticate

  def index
    @profiles = Profile.all
    @user_profiles = Profile.find(:all, :conditions => { :type => 'UserProfile' })
    @game_profiles = Profile.find(:all, :conditions => { :type => 'GameProfile' })
    respond_with(@profiles, @site_profiles, @game_profiles)
  end

  def show
    @profile = Profile.find(params[:id])
    if @profile.game_id != nil
      @game = Game.find(@profile.game_id)
    end

    if @profile.type == "GameProfile"
      respond_with(@profile) # TODO Verify that this is correct.
    else
      respond_with(@profile)
    end
  end

  def new
    if @profile_type == "UserProfile" || current_user.user_profile == nil || @profile_type == nil
      add_new_flash_message("Please create a user profile to finish creating your account.",'alert')
      @profile = UserProfile.new
      @profile.type = "UserProfile"
    else
      add_new_flash_message("Please create a game profile.",'alert')
      @profile = GameProfile.new
      @profile.type = "GameProfile"
    end
    @profile.user = current_user
    respond_with(@profile)
  end

  def edit
    @profile = Profile.find(params[:id])
    respond_with(@profile)
  end

  def create
    if @profile == nil
      logger.debug "profile was nil"
      @profile = UserProfile.new(params[:profile])
      @profile.user = current_user
    else
      @profile.update_attributes(params[:profile])
    end
    if @profile.save
      add_new_flash_message('Profile was successfully created.')
    end
    grab_all_errors_from_model(@profile)
    respond_with(@profile)
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
        add_new_flash_message('Profile was successfully updated.')
    end
    grab_all_errors_from_model(@profile)
    repsond_with(@profile)
  end

  def destroy
    @profile = Profile.find(params[:id])
    if @profile.destroy
      add_new_flash_message('Profile was successfully deleted.')
    end
    grab_all_errors_from_model(@profile)
    repsond_with(@profile)
  end
end
