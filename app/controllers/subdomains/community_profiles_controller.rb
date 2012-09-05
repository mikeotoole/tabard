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
  load_and_authorize_resource only: [:destroy]
  skip_before_filter :enforce_community_features, only: [:destroy]

###
# REST Actions
###

  # DELETE /community_profiles/:id(.:format)
  def destroy
    @community_profile.force_destroy = true
    if @community_profile.destroy
      community_application = @community_profile.community_application
      community_application.remove_from_community(current_user.user_profile)
      if @community_profile.user_profile == current_user.user_profile
        flash[:success] = "You have left the \"#{current_community.name}\" community."
        redirect_to root_url(subdomain: current_community.subdomain)
        return
      else
        flash[:notice] = "#{@community_profile.user_profile_display_name} has been removed from the community."
      end
    end
    respond_with @community_profile, location: roster_assignments_url
  end
end