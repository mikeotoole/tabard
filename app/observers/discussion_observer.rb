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
    Activity.create!( user_profile: discussion.user_profile,
                        community: discussion.community,
                        target: discussion,
                        action: "created")
  end

  # Creates an activity when a discussion is updated.
  def after_update(discussion)
    if discussion.changed?
      Activity.create!( user_profile: discussion.user_profile,
                        community: discussion.community,
                        target: discussion,
                        action: "edited")
    end
  end
end
