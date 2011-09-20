###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community.
###
class Community < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :name, :slogan, :accepting_members, :email_notice_on_application

###
# Associations
###
  belongs_to :admin_profile, :class_name => "UserProfile"
  belongs_to :member_role, :class_name => "Role"
  has_many :roles
  has_many :supported_games
  has_many :games, :through => :supported_games
  has_many :custom_forms, :dependent => :destroy
  has_many :community_profiles

###
# Callbacks
###
  before_save :update_subdomain
  after_create :set_up_member_role, :make_admin_a_member

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

  validates :admin_profile, :presence => true

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
  # This method gets the current communtiy roster. An option game may be specified.
  # [Args]
  #   * +game+ -> The user profile you would like to promote to a member.
  # [Returns] An array of character_proxies, optionly filtered by game.
  ###
  def get_current_community_roster(game = nil)
    # TODO Joe Check this for optimization potential.
    community_roster = Array.new
    self.community_profiles.each do |profile|
      if game
        profile.approved_character_proxies.each do |proxy|
          community_roster << proxy if proxy.game == game
        end
      else 
        community_roster = community_roster + profile.approved_character_proxies
      end
    end
    return community_roster
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
#  accepting_members           :boolean         default(TRUE)
#  email_notice_on_application :boolean         default(TRUE)
#  subdomain                   :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#  admin_profile_id            :integer
#  member_role_id              :integer
#  protected_roster            :boolean         default(FALSE)
#

