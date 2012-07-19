###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for CommunityApplication. It is used to create an activity when a user is accpeted to a community.
###
class CommunityApplicationObserver < ActiveRecord::Observer

  # Creates an activity when a user is accpeted to a community.
  def after_update(community_application)
    if community_application.changed? and community_application.status == "Accepted"
      activity = Activity.where(user_profile_id: community_application.user_profile_id,
                                community_id: community_application.community_id,
                                target_type: "UserProfile",
                                target_id: community_application.user_profile_id).first

      Activity.create!( user_profile: community_application.user_profile,
                        community: community_application.community,
                        target: community_application.user_profile,
                        action: "accepted") unless activity
    end
  end

  # removes activity
  def after_destroy(community_application)
    target = community_application
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
  end
end
