###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for RosterAssignment. It is used to create an activity when a character is accpeted to a community.
###
class RosterAssignmentObserver < ActiveRecord::Observer
  
  def after_save(roster_assignment)
    unless roster_assignment.is_pending
#       activity = Activity.where(:user_profile_id => roster_assignment.user_profile.id, 
#                                 :community_id => roster_assignment.community.id,
#                                 :target_type => roster_assignment.class.name,
#                                 :target_id => roster_assignment.id).first
    
      Activity.create!( :user_profile => roster_assignment.user_profile, 
                        :community => roster_assignment.community, 
                        :target => roster_assignment, # TODO Doug/Mike, Should this make the character or roster_assignment the target
                        :action => "added to roster")
    end  
  end
end