###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community.
###
class Community < ActiveRecord::Base
###
# Constants
###
  VALID_LABELS = %w(Guild Team Clan Faction Squad)

###
# Attribute accessible
###
  attr_accessible :name, :slogan, :label, :accepting_members, :admin_profile, :member_role, :member_role_id, :email_notice_on_application

###
# Associations
###
  has_many :roles
  belongs_to :member_role, :class_name => "Role"
  belongs_to :admin_profile, :class_name => "UserProfile"

  has_many :community_profiles
  has_many :member_profiles, :through => :community_profiles, :source => :user_profile

###
# Validators
###
  validates :name, :uniqueness => { :case_sensitive => false },
                   :presence => true,
                   :exclusion => { :in => %w(www wwW wWw wWW Www WwW WWw WWW), :message => "%{value} is not available" },
                   :format => { :with => /\A[a-zA-Z0-9 \-]+\z/, :message => "Only letters, numbers, dashes and spaces are allowed" }
  validates :name, :community_name => true, :on => :create
  validate :can_not_change_name, :on => :update
  validates :slogan, :presence => true
  validates :label, :presence => true,
                   :inclusion => { :in => VALID_LABELS, :message => "%{value} is not currently a supported label" }

  validates :admin_profile, :presence => true

###
# Callbacks
###
  before_save :update_subdomain
  after_create :set_up_member_role, :make_admin_a_member

###
# Public Methods
###
  ###
  # This method promotes a user to a member, doing all of the business logic for you.
  # [Args]
  #   * +user_profile+ -> The user profile you would like to promote to a member.
  # [Returns] A boolean that contains the result of the operation. True if successful, otherwise false.
  ###
  def promote_user_profile_to_member(user_profile)
    # TODO Joe/Mike Ensure that the user is an applicant -JW
    return user_profile.community_profiles.create(:community => self, :roles => [self.member_role])
  end

###
# Protected Methods
###
protected

  ###
  # _before_save_
  #
  # This method automatically updates this community's subdomain from this community's name.
  # [Returns] False if an error occured, otherwise true.
  ###
  def update_subdomain
    self.subdomain = Community.convert_to_subdomain(name)
  end

  ###
  # This method converts the name passed to it into the corrosponding subdomain representation.
  # [Args]
  #   * +name+ -> The string to convert using the subdomain transformation.
  # [Returns] A string who is downcased and has spaces and dashes removed.
  ###
  def self.convert_to_subdomain(name)
    return false if name.blank?
    name.downcase.gsub(/[\s\-]/,"")
  end

  ###
  # This method ensures that the name is not changed.
  ###
  def can_not_change_name
    if self.name_changed?
      self.name = self.name_was
      self.errors.add(:name, "can not be changed.")
      return false
    end
  end

  ###
  # _after_create_
  #
  # This method creates the default member role.
  ###
  def set_up_member_role
    default_member_role = Role.create(:name => "Member", :system_generated => true, :community => self)
    default_member_role.community.update_attribute(:member_role, default_member_role) # OPTIMIZE Joe, this looks like it could use some optimization. -JW

  end

  ###
  # _after_create_
  #
  # This method makes the admin a member.
  ###
  def make_admin_a_member
    self.promote_user_profile_to_member(self.admin_profile)
  end
end




# == Schema Information
#
# Table name: communities
#
#  id                          :integer         not null, primary key
#  name                        :string(255)
#  slogan                      :string(255)
#  label                       :string(255)
#  accepting_members           :boolean         default(TRUE)
#  email_notice_on_application :boolean         default(TRUE)
#  subdomain                   :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  admin_profile_id            :integer
#  member_role_id              :integer
#

