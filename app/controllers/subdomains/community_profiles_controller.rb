###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling community profiles within communities.
###
class Subdomains::CommunityProfilesController < SubdomainsController

###
# Before Filters
###
  load_resource :only => [:destroy]

###
# REST Actions
###

  # DELETE /community_profiles/:id(.:format)
  def destroy
    @community_profile.force_destroy = true
    if @community_profile.destroy
      add_new_flash_message "#{@community_profile.user_profile_display_name} has been removed from the community.", 'notice'
    else
      add_new_flash_message 'Unable to remove member.', 'alert'
    end
    redirect_to roster_assignments_url
  end
end