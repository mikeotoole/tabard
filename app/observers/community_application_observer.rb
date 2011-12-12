###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for CommunityApplication. It is used to create an activity when a user is accpeted to a community.
###
class CommunityApplicationObserver < ActiveRecord::Observer
  
  def after_update(community_application)
    if community_application.changed? and community_application.status == "Accepted"
      activity = Activity.where(:user_profile_id => community_application.user_profile_id, 
                                :community_id => community_application.community_id,
                                :target_type => "UserProfile",
                                :target_id => community_application.user_profile_id).first
                                
      Activity.create!( :user_profile => community_application.user_profile, 
                        :community => community_application.community, 
                        :target => community_application.user_profile, 
                        :action => "accepted") unless activity
    end  
  end
end