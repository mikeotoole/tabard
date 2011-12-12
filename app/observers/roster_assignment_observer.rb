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
      Activity.create!( :user_profile => roster_assignment.user_profile, 
                        :community => roster_assignment.community, 
                        :target => roster_assignment.character_proxy,
                        :action => "accepted")
    end  
  end
end