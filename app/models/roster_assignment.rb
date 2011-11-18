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
  has_one :user_profile, :through => :community_profile

###
# Validators
###
  validates :community_profile, :presence => true
  validates :character_proxy, :presence => true
  validates :character_proxy_id, :uniqueness => { :scope => "community_profile_id", :message => "is already rostered to the community."}

###
# Delegates
### 
  delegate :user_profile, :user_profile_id, :to => :community_profile, :prefix => true, :allow_nil => true
  delegate :community_admin_profile_id, :to => :community_profile, :allow_nil => true
  delegate :name, :avatar_url, :to => :character_proxy, :prefix => true
  delegate :display_name, :to => :user_profile, :prefix => true
  delegate :avatar_url, :to => :user_profile, :prefix => true
  delegate :name, :to => :character_proxy, :prefix => true

###
# Callbacks
###
  before_create :ensure_proper_pending_status

  # This method approves this roster assignment, if it is pending.
  # [Returns] True if this was approved, otherwise false.
  def approve
    return false unless self.pending
    self.update_attribute(:pending, false)
    # TODO Mike, Send message to owner -JW
  end

  # This method rejects this roster assignment, if it is pending.
  # [Returns] True if this was rejected, otherwise false.
  def reject
    return false unless self.pending
    self.destroy
    # TODO Mike, Send message to owner -JW
  end

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

