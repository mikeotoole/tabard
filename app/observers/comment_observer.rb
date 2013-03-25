###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for Comment. It is used to create an activity when a Comment is created or edited.
###
class CommentObserver < ActiveRecord::Observer


  # Creates an activity when a new comment is created.
  def after_create(comment)
    Activity.create!( {user_profile: comment.user_profile,
                        community: comment.community,
                        target: comment,
                        action: "created"}, without_protection: true)
  end

  # Creates an activity when a comment is updated.
  def after_update(comment)
    # Removed Per BVR-969
    #if comment.changed?
    #  Activity.create!( {user_profile: comment.user_profile,
    #                    community: comment.community,
    #                    target: comment,
    #                    action: "edited"}, without_protection: true)
    #end
  end

  # removes activity with comment
  def after_destroy(comment)
    target = comment
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
  end
end
