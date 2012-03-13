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
    Activity.create!( :user_profile => comment.user_profile,
                        :community => comment.community,
                        :target => comment,
                        :action => "created")
  end

  # Creates an activity when a comment is updated.
  def after_update(comment)
    if comment.changed?
      Activity.create!( :user_profile => comment.user_profile,
                        :community => comment.community,
                        :target => comment,
                        :action => "edited")
    end
  end
end
