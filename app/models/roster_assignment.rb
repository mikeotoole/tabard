###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an assignment of a character_proxy to a community profile.
###
class RosterAssignment < ActiveRecord::Base
  validates_lengths_from_database
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Associations
###
  belongs_to :community_profile, touch: true
  belongs_to :character_proxy
  belongs_to :supported_game
  has_one :user_profile, through: :community_profile

###
# Validators
###
  validates :community_profile, presence: true
  validates :character_proxy_id, uniqueness: { scope: ["community_profile_id", "deleted_at"], message: "is already rostered to the community."}
  validate :character_and_game_must_be_present
  validate :community_valid_for_supported_game
  validate :character_valid_for_supported_game

###
# Delegates
###
  delegate :user_profile, :user_profile_id, to: :community_profile, prefix: true, allow_nil: true
  delegate :community_admin_profile_id, to: :community_profile, allow_nil: true
  delegate :community, to: :community_profile, allow_nil: true
  delegate :name, :avatar_url, to: :character_proxy, prefix: true
  delegate :display_name, to: :user_profile, prefix: true
  delegate :avatar_url, to: :user_profile, prefix: true
  delegate :name, to: :character_proxy, prefix: true
  delegate :character, to: :character_proxy
  delegate :name, to: :supported_game, prefix: true
  delegate :smart_name, to: :supported_game, prefix: true

###
# Callbacks
###
  before_create :ensure_proper_pending_status

###
# Public Methods
###

###
# Instance Methods
###
  # This method approves this roster assignment, if it is pending.
  # [Returns] True if this was approved, otherwise false.
  def approve(message=true)
    return false unless self.is_pending
    self.update_attribute(:is_pending, false)
    message = Message.create_system(subject: "Character Accepted", body: "Your request to add #{self.character_proxy.name} to #{self.community_profile.community_name} has been accepted.", to: [self.community_profile_user_profile_id]) if message
  end

  # This method rejects this roster assignment, if it is pending.
  # [Returns] True if this was rejected, otherwise false.
  def reject(message=true)
    return false unless self.is_pending
    self.destroy
    message = Message.create_system(subject: "Character Rejected", body: "Your request to add #{self.character_proxy.name} to #{self.community_profile.community_name} has been rejected.", to: [self.community_profile_user_profile_id]) if message
  end

###
# Protected Methods
###
  protected

###
# Validator Methods
###
  # This method validates that a character and supported game are presenet.
  def character_and_game_must_be_present
    errors.add(:base, "You need to select a game.") if supported_game.blank?
    errors.add(:base, "You need to select a character.") if character_proxy.blank?
  end
  # This method validates that the community is compatable with the supported game
  def community_valid_for_supported_game
    errors.add(:base, "Community and supported game do not match.") if self.community_profile != nil and self.supported_game != nil and self.community_profile.community != self.supported_game.community
  end

  # This method validates that the character is compatable with the supported game
  def character_valid_for_supported_game
    errors.add(:base, "That character is not compatible with #{self.supported_game.game_short_name}.") if self.character_proxy != nil and self.supported_game != nil and self.character_proxy.game.class.to_s != self.supported_game.game_type
  end

###
# Callback Methods
###
  ###
  # _before_create_
  #
  # This method automatically ensures that a roster assignment has the pending status set properly, based on the community rules.
  # [Returns] False if an error occured, otherwise true.
  ###
  def ensure_proper_pending_status
    if self.community_profile.community.is_protected_roster
      self.is_pending = true
    else
      self.is_pending = false
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
#  is_pending           :boolean         default(TRUE)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  deleted_at           :datetime
#  supported_game_id    :integer
#

