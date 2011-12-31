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
# Attribute accessible
###
  attr_accessor :force_destroy
  
###
# Associations
###
  # TODO Joe/Bryan We need to evaluate the eager loading of associations and inverse_of to optimize our memory footprints and speed. -JW
  belongs_to :community
  belongs_to :user_profile
  has_and_belongs_to_many :roles, :before_add => :ensure_that_role_community_matches, :before_remove => :ensure_that_member_role_stays
  has_many :approved_roster_assignments, :class_name => "RosterAssignment", :conditions => {:is_pending => false}
  has_many :approved_character_proxies, :through => :approved_roster_assignments, :source => "character_proxy"
  has_many :pending_roster_assignments, :class_name => "RosterAssignment", :conditions => {:is_pending => true}
  has_many :pending_character_proxies, :through => :pending_roster_assignments, :source => "character_proxy"
  has_many :roster_assignments, :dependent => :destroy
  has_many :character_proxies, :through => :roster_assignments, :before_add => :ensure_that_character_proxy_user_matches

###
# Validators
###
  validates :community, :presence => true
  validates :user_profile, :presence => true
  validates :user_profile_id, :uniqueness => {:scope => :community_id}, :unless => Proc.new {|community_profile| community_profile.user_profile.blank? }
  validate :has_at_least_the_default_member_role

###
# Delegates
###
  delegate :admin_profile_id, :to => :community, :prefix => true
  delegate :id, :to => :user_profile, :prefix => true
  delegate :name, :to => :user_profile, :prefix => true
  delegate :display_name, :to => :user_profile, :prefix => true
  delegate :name, :to => :community, :prefix => true

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
  def ensure_that_character_proxy_user_matches(character_proxy)
    raise InvalidCollectionAddition.new("You can't add a character_proxy from a different user.") if character_proxy and character_proxy.user_profile != self.user_profile
  end


  ###
  # This method ensures that the community matches when a role is added.
  # [Args]
  #   * +role+ -> The role being added to the collection.
  ###
  def ensure_that_role_community_matches(role)
    raise InvalidCollectionAddition.new("You can't add a role from a different community.") if role and role.community != self.community
  end

  ###
  # This method ensures that the community member role is not removed.
  # [Args]
  #   * +role+ -> The role being removed from the collection.
  ###
  def ensure_that_member_role_stays(role)
    if not self.force_destroy and not self.user_profile.disabled and role == self.community.member_role
      raise InvalidCollectionRemoval.new("You can't remove the member role.")
    end
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

