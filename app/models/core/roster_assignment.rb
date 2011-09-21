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
  validates :character_proxy_id, :uniqueness => { :scope => "community_profile_id", :message => "is already rostered to the community."}

###
# Delegates
###
  delegate :user_profile, :to => :community_profile, :prefix => true

###
# Callbacks
###
  before_create :ensure_proper_pending_status

###
# Protected Methods
###
  protected

  ###
  # _before_create_
  #
  # This method automatically ensures that a roster assignment has the pending status set properly, based on the community rules.
  # [Returns] False if an error occured, otherwise true.
  ###
  def ensure_proper_pending_status
    if self.community_profile.community.protected_roster
      self.pending = true
    else
      self.pending = false
    end
    true
  end
end

# == Schema Information
#
# Table name: roster_assignments
#
#  id                   :integer         not null, primary key
#  community_profile_id :integer
#  character_proxy_id   :integer
#  pending              :boolean         default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#
