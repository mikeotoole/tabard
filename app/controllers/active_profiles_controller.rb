###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for creating the active profile.
###
class ActiveProfilesController < ApplicationController

  before_filter :authenticate_user!
  skip_before_filter :limit_subdomain_access

  #This creates the active profile, if possible.
  def create
    if params[:type] =~ /UserProfile|Character$/
      if defined? params[:type].constantize
        profile = params[:type].constantize.find_by_id(params[:id])
      end

      if profile and profile.owned_by_user?(current_user)
        session[:profile_id] = params[:id]
        session[:profile_type] = params[:type]
        active_profile_name = profile.name
        add_new_flash_message("Profile <em>#{active_profile_name}</em> activated.")
        redirect_to previous_page
        return
      else
        add_new_flash_message("Error setting active profile","alert")
        redirect_to root_path
        return
      end
    else
      add_new_flash_message("Error setting active profile","alert")
      redirect_to root_path
      return
    end
  end
end
