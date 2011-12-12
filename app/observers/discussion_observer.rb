###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for Discussion. It is used to create an activity when a Discussion is created or edited.
###
class DiscussionObserver < ActiveRecord::Observer
  
  def after_save(discussion)
    if discussion.created_at == discussion.updated_at    
      Activity.create!( :user_profile => discussion.user_profile, 
                        :community => discussion.community, 
                        :target => discussion,
                        :action => "created discussion")
    else
      Activity.create!( :user_profile => discussion.user_profile, 
                        :community => discussion.community, 
                        :target => discussion,
                        :action => "edited discussion")
    end  
  end
end