###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an assignment of a character_proxy to a community profile. 
###
class RosterAssignment < ActiveRecord::Base

###
# Associations
###
  belongs_to :community_profile
  belongs_to :character_proxy

###
# Validators
###
  validates :community_profile, :presence => true
  validates :character_proxy, :presence => true
  validates :pending, :presence => true
end
