###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an assignment of a character to a community profile.
###
class RosterAssignment < ActiveRecord::Base
  validates_lengths_from_database
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid
###
# Attribute accessible
###
  attr_accessible :community_profile, :character, :community_game, :character_id, :community_game_id

###
# Associations
###
  belongs_to :community_profile, touch: true
  belongs_to :character
  belongs_to :community_game
  has_one :user_profile, through: :community_profile

###
# Validators
###
  validates :community_profile, presence: true
  validates :character_id, uniqueness: { scope: ["community_profile_id", "deleted_at"], message: "is already rostered to the community."}
  validate :character_and_game_must_be_present
  validate :community_valid_for_community_game
  validate :character_valid_for_community_game

###
# Delegates
###
  delegate :user_profile, :user_profile_id, to: :community_profile, prefix: true, allow_nil: true
  delegate :community_admin_profile_id, to: :community_profile, allow_nil: true
  delegate :community, to: :community_profile, allow_nil: true
  delegate :name, :avatar_url, to: :character, prefix: true
  delegate :display_name, to: :user_profile, prefix: true
  delegate :avatar_url, to: :user_profile, prefix: true
  delegate :name, to: :character, prefix: true
  delegate :name, to: :community_game, prefix: true
  delegate :smart_name, to: :community_game, prefix: true

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
    self.update_attributes({is_pending: false}, without_protection: true)
    message = Message.create_system(subject: "Character Accepted", body: "Your request to add #{self.character.name} to #{self.community_profile.community_name} has been accepted.", to: [self.community_profile_user_profile_id]) if message
  end

  # This method rejects this roster assignment, if it is pending.
  # [Returns] True if this was rejected, otherwise false.
  def reject(message=true)
    return false unless self.is_pending
    self.destroy
    message = Message.create_system(subject: "Character Rejected", body: "Your request to add #{self.character.name} to #{self.community_profile.community_name} has been rejected.", to: [self.community_profile_user_profile_id]) if message
  end

###
# Protected Methods
###
  protected

###
# Validator Methods
###
  # This method validates that a character and Community game are presenet.
  def character_and_game_must_be_present
    errors.add(:base, "You need to select a game.") if community_game.blank?
    errors.add(:base, "You need to select a character.") if character.blank?
  end
  # This method validates that the community is compatable with the supported game
  def community_valid_for_community_game
    errors.add(:base, "Community and supported game do not match.") if self.community_profile != nil and self.community_game != nil and self.community_profile.community != self.community_game.community
  end

  # This method validates that the character is compatable with the supported game
  def character_valid_for_community_game
    errors.add(:base, "That character is not compatible with #{self.community_game.game_name}.") if self.character != nil and self.community_game != nil and self.character.game_id != self.community_game.game_id
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
#  id                   :integer          not null, primary key
#  community_profile_id :integer
#  is_pending           :boolean          default(TRUE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  deleted_at           :datetime
#  supported_game_id    :integer
#  community_game_id    :integer
#  character_id         :integer
#

