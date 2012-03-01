###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling community profiles within communities.
###
class Subdomains::CommunityProfilesController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  load_and_authorize_resource :only => [:destroy]

###
# REST Actions
###

  # DELETE /community_profiles/:id(.:format)
  def destroy
    @community_profile.force_destroy = true
    if @community_profile.destroy
      if @community_profile.user_profile == current_user.user_profile
        add_new_flash_message "You have left the \"#{current_community.name}\" community.", 'success'
        redirect_to root_url(:subdomain => current_community.subdomain)
        return
      else
        add_new_flash_message "#{@community_profile.user_profile_display_name} has been removed from the community.", 'notice'
      end
    end
    respond_with @community_profile, :location => roster_assignments_url
  end
end