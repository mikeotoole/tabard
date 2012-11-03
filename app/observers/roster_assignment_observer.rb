###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is an observer for RosterAssignment. It is used to create an activity when a character is accpeted to a community.
###
class RosterAssignmentObserver < ActiveRecord::Observer

  # Creates an activity when a character is accepted to a communty.
  def after_update(roster_assignment)
    unless roster_assignment.is_pending
      Activity.create!( {user_profile: roster_assignment.user_profile,
                        community: roster_assignment.community,
                        target: roster_assignment.character,
                        action: "accepted"}, without_protection: true)
    end
  end

  # removes activity
  def after_destroy(roster_assignment)
    target = roster_assignment
    Activity.where(target_type: target.class.to_s, target_id: target.id).destroy_all
  end
end
