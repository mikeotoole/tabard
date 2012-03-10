###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This model represents a community profile.
###
class CommunityProfile < ActiveRecord::Base
  include Exceptions

  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

###
# Attribute accessible
###
  attr_accessor :force_destroy

###
# Associations
###
  # TODO Joe/Bryan We need to evaluate the eager loading of associations and inverse_of to optimize our memory footprints and speed. -JW
  belongs_to :community, :inverse_of => :community_profiles
  belongs_to :user_profile
  belongs_to :community_application
  has_and_belongs_to_many :roles, :before_add => :ensure_that_role_community_matches, :before_remove => :ensure_that_member_role_stays
  has_many :acknowledgements
  has_many :unread_acknowledgements, :conditions => {:has_been_viewed => false}, :class_name => "Acknowledgement"
  has_many :read_acknowledgements, :conditions => {:has_been_viewed => true}, :class_name => "Acknowledgement"
  has_many :announcements, :through => :acknowledgements
  has_many :unread_announcements, :through => :unread_acknowledgements, :source => "announcement"
  has_many :read_announcements, :through => :read_acknowledgements, :source => "announcement"
  has_many :roster_assignments, :dependent => :destroy
  has_many :character_proxies, :through => :roster_assignments, :before_add => :ensure_that_character_proxy_user_matches
  has_many :approved_roster_assignments, :class_name => "RosterAssignment", :conditions => {:is_pending => false}
  has_many :approved_character_proxies, :through => :approved_roster_assignments, :source => "character_proxy"
  has_many :pending_roster_assignments, :class_name => "RosterAssignment", :conditions => {:is_pending => true}
  has_many :pending_character_proxies, :through => :pending_roster_assignments, :source => "character_proxy"

###
# Callbacks
###
  before_destroy :ensure_that_community_profile_is_not_admin

###
# Validators
###
  validates :community, :presence => true
  validates :user_profile, :presence => true
  validates :user_profile_id, :uniqueness => {:scope => [:community_id, :deleted_at]},
                                :unless => Proc.new { |community_profile| community_profile.user_profile.blank? }
  validate :has_at_least_the_default_member_role
  validate :has_at_least_the_default_member_role

###
# Delegates
###
  delegate :id, :to => :user_profile, :prefix => true
  delegate :name, :to => :user_profile, :prefix => true
  delegate :display_name, :to => :user_profile, :prefix => true
  delegate :name, :to => :community, :prefix => true
  delegate :is_email_on_announcement, :to => :user_profile

  ###
  # This method determines if this community profile has character that matches supported game.
  # [Args]
  #   * +supported_game+ -> The supported game.
  ###
  def has_character_that_matches_supported_game(supported_game)
    self.character_proxies.each do |proxy|
      return true if proxy.game.class.to_s == supported_game.game_type
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
  # This method ensures that this profile has the default role.
  def has_at_least_the_default_member_role
    errors.add(:roles, "must not be empty") if self.roles.blank?
    errors.add(:roles, "must include the member role of the community.") unless self.community and self.roles.include?(self.community.member_role)
  end

###
# Callbacks
###
  ###
  # _before_add_ on character_proxies
  #
  # This method ensures that the community matches when a role is added.
  # [Args]
  #   * +role+ -> The role being added to the collection.
  ###
  def ensure_that_character_proxy_user_matches(character_proxy)
    raise InvalidCollectionAddition.new("You can't add a character_proxy from a different user.") if character_proxy and character_proxy.user_profile != self.user_profile
  end

  ###
  # _before_add_ on roles
  #
  # This method ensures that the community matches when a role is added.
  # [Args]
  #   * +role+ -> The role being added to the collection.
  ###
  def ensure_that_role_community_matches(role)
    raise InvalidCollectionAddition.new("You can't add a role from a different community.") if role and role.community != self.community
  end

  ###
  # _before_remove_ on roles
  #
  # This method ensures that the community member role is not removed.
  # [Args]
  #   * +role+ -> The role being removed from the collection.
  ###
  def ensure_that_member_role_stays(role)
    if not self.force_destroy and not self.user_profile.is_disabled? and role == self.community.member_role
      raise InvalidCollectionRemoval.new("You can't remove the member role.")
    end
  end

  # This method prevents the community admin's community profile from being destroyed
  def ensure_that_community_profile_is_not_admin
    if self.community and self.user_profile == self.community.admin_profile
      errors.add(:base, "Cannot remove community admin.")
      return false
    end
  end
end






# == Schema Information
#
# Table name: community_profiles
#
#  id                       :integer         not null, primary key
#  community_id             :integer
#  user_profile_id          :integer
#  created_at               :datetime
#  updated_at               :datetime
#  deleted_at               :datetime
#  community_application_id :integer
#

