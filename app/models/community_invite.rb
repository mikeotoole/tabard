###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an invitation to a community.
###
class CommunityInvite < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :applicant, :applicant_id, :community_id, :sponsor_id, :email

###
# Associations
###
  belongs_to :applicant, class_name: "UserProfile", inverse_of: :community_invite_applications
  belongs_to :sponsor, class_name: "UserProfile", inverse_of: :community_invite_sponsors
  belongs_to :community, inverse_of: :community_invites

###
# Validators
###
  validates :applicant_id, uniqueness: {scope: [:sponsor_id, :community_id], message: "has aleady been sent an invite"}, unless: Proc.new{|ci| ci.applicant_id.blank? }
  validates :email, uniqueness: {scope: [:sponsor_id, :community_id], case_sensitive: true, message: "has aleady been sent an invite"},
            length: { within: 5..128 },
            format: { with: %r{\A(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})\Z}i },
            unless: Proc.new{|ci| ci.email.blank? }
  validates :applicant, presence: true, if: Proc.new{|ci| ci.email.blank? }
  validates :email, presence: true, if: Proc.new{|ci| ci.applicant.blank? }

  validates :sponsor, presence: true
  validates :community, presence: true
  validate :applicant_cant_be_the_same_as_sponsor
  validate :sponsor_must_be_member_of_community
  validate :applicant_cant_be_a_member_of_the_community

###
# Delegates
###
  delegate :name, to: :community, prefix: true
  delegate :subdomain, to: :community, prefix: true
  delegate :display_name, to: :sponsor, prefix: true
  delegate :display_name, to: :applicant, prefix: true

###
# Callbacks
###
  before_create :try_to_find_user
  after_create :remove_action_item

  # Checks to see if this is a duplicate
  def is_a_duplicate?
    unless self.errors[:email].blank?
      return true if self.errors[:email].include?("has aleady been sent an invite")
    end
    unless self.errors[:applicant_id].blank?
      return true if self.errors[:applicant_id].include?("has aleady been sent an invite")
    end
    return false
  end

###
# Protected Methods
###
protected

###
# Validator Methods
###
  ###
  # This method validates that the applicant can't also be the sponsor.
  ###
  def applicant_cant_be_the_same_as_sponsor
    return false if sponsor.blank? or applicant.blank?
    self.errors.add(:base, "The sponsor can't be the applicant") if self.sponsor == self.applicant
  end

  ###
  # This method validates that sponsor must be in the community.
  ###
  def sponsor_must_be_member_of_community
    return false if sponsor.blank? or community.blank?
    self.errors.add(:base, "The sponsor must be a member of the community") unless self.sponsor.is_member?(self.community)
  end

  ###
  # This method validates that applicant is not a member
  ###
  def applicant_cant_be_a_member_of_the_community
    return false if applicant.blank? or community.blank?
    self.errors.add(:base, "The applicant can't be a member of the community") if self.applicant.is_member?(self.community)
  end

###
# Callback Methods
###
  ###
  # _after_create_
  #
  # This method removes action item from community.
  ###
  def remove_action_item
    if self.community.action_items.any? and self.community.community_invites.size > 1
      self.community.action_items.delete(:send_invites)
      self.community.save!
    end
  end

  ###
  # _before_create_
  #
  # This method trys to find a user with the email
  ###
  def try_to_find_user
    unless self.email.blank? or not self.valid?
      user = User.find_by_email(self.email.downcase)
      return true if user.blank?
      self.errors.add(:base, "The sponsor can't be the applicant") and return false if self.sponsor == user.user_profile
      self.errors.add(:email, "has aleady been sent an invite") and return false unless CommunityInvite.find_by_sponsor_id_and_community_id_and_applicant_id(self.sponsor.id, self.community.id, user.user_profile_id).blank?
      self.applicant = user.user_profile
      self.email = nil
    end
  end
end

# == Schema Information
#
# Table name: community_invites
#
#  id           :integer          not null, primary key
#  applicant_id :integer
#  sponsor_id   :integer
#  community_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  email        :string(255)
#

