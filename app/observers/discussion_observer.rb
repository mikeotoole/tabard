###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for Discussion. It is used to create an activity when a Discussion is created or edited.
###
class DiscussionObserver < ActiveRecord::Observer


  # Creates an activity when a new discussion is created.
  def after_create(discussion)
    Activity.create!( {user_profile: discussion.user_profile,
                        community: discussion.community,
                        target: discussion,
                        action: "created"}, without_protection: true)
  end

  # Creates an activity when a discussion is updated.
  def after_update(discussion)
    if discussion.changed?
      Activity.create!( {user_profile: discussion.user_profile,
                        community: discussion.community,
                        target: discussion,
                        action: "edited"}, without_protection: true)
    end
  end

  # removes activity
  def after_destroy(discussion)
    target = discussion
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
  end
end
