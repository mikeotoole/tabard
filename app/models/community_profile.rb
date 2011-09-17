###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This model represents a community profile.
###
class CommunityProfile < ActiveRecord::Base
  include Exceptions
###
# Associations
###
  # TODO Joe/Bryan We need to evaluate the eager loading of associations and inverse_of to optimize our memory footprints and speed. -JW
  belongs_to :community
  belongs_to :user_profile
  has_and_belongs_to_many :roles, :before_add => :ensure_that_community_matches, :before_remove => :ensure_that_member_role_stays
  has_many :roster_assignments
  has_many :character_proxies, :through => :roster_assignments

###
# Validators
###
  validates :community, :presence => true
  validates :user_profile, :presence => true
  validates :user_profile_id, :uniqueness => {:scope => :community_id}
  validate :has_at_least_the_default_member_role

###
# Public Methods
###
  # This method ensures that this profile has the default role.
  def has_at_least_the_default_member_role
    errors.add(:roles, "must not be empty") if self.roles.blank?
    errors.add(:roles, "must include the member role of the community.") unless self.community and self.roles.include?(self.community.member_role)
  end

  ###
  # This method ensures that the community matches when a role is added.
  # [Args]
  #   * +role+ -> The role being added to the collection.
  ###
  def ensure_that_community_matches(role)
    raise InvalidCollectionAddition.new("You can't add a role from a different community.") if role and role.community != self.community
  end

  ###
  # This method ensures that the community member role is not removed.
  # [Args]
  #   * +role+ -> The role being removed from the collection.
  ###
  def ensure_that_member_role_stays(role)
    raise InvalidCollectionRemoval.new("You can't remove the member role.") if role == self.community.member_role
  end
end


# == Schema Information
#
# Table name: community_profiles
#
#  id              :integer         not null, primary key
#  community_id    :integer
#  user_profile_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

