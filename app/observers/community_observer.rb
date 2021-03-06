###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for Community. It is used to create an activity when a new community is created.
###
class CommunityObserver < ActiveRecord::Observer

  # Creates an activity when a Community is created.
  def after_create(community)
    Activity.create!( {user_profile: community.admin_profile,
                      community: community,
                      target: community,
                      action: "created"}, without_protection: true)
  end

  # removes activites
  def after_destroy(community)
    target = community
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
  end
end
