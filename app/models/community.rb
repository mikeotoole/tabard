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
  belongs_to :community_application_form, :dependent => :destroy, :class_name => "CustomForm"
  has_many :community_applications
  has_many :roles
  has_many :supported_games, :dependent => :destroy
  has_many :games, :through => :supported_games
  has_many :game_announcement_spaces, :through => :supported_games
  has_many :custom_forms, :dependent => :destroy
  has_many :community_profiles
  has_many :discussion_spaces, :class_name => "DiscussionSpace", :conditions => {:is_announcement => false}, :dependent => :destroy
  has_many :announcement_spaces, :class_name => "DiscussionSpace", :conditions => {:is_announcement => true}, :dependent => :destroy
  belongs_to :community_announcement_space, :class_name => "DiscussionSpace", :dependent => :destroy
  has_many :discussions, :through => :discussion_spaces
  has_many :comments
  has_many :page_spaces
  has_many :pages, :through => :page_spaces

###
# Callbacks
###
  before_save :update_subdomain
  after_create :setup_member_role, :make_admin_a_member, :setup_community_application_form, :make_community_announcement_space

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
# Instance Methods
###
  ###
  # This method promotes a user to a member, doing all of the business logic for you.
  # [Args]
  #   * +user_profile+ -> The user profile you would like to promote to a member.
  # [Returns] The community profile that was created, otherwise nil if it could not be created.
  ###
  def promote_user_profile_to_member(user_profile)
    return nil unless (self.community_applications.where{(:user_profile == user_profile)}.exists? or
        self.admin_profile == user_profile)
    user_profile.community_profiles.create(:community => self, :roles => [self.member_role])
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
# Class Methods
###
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
# Instance Methods
###
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
# Callback Methods
###
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
  # _after_create_
  #
  # This method creates the default member role.
  ###
  def setup_member_role
    mr = self.build_member_role(:name => "Member", :system_generated => true)
    mr.community = self
    mr.save
    self.update_attribute(:member_role, mr)
  end

  ###
  # _after_create_
  #
  # This method creates the default member role.
  ###
  def setup_community_application_form
    ca = self.build_community_application_form(:name => "Application Form",
        :instructions => "Fill this out please.",
        :thankyou => "Thanks!",
        :published => true)
    ca.community = self
    ca.save
    self.update_attribute(:community_application_form, ca)
  end

  ###
  # _after_create_
  #
  # This method makes the admin a member.
  ###
  def make_admin_a_member
    self.promote_user_profile_to_member(self.admin_profile)
  end

  ###
  # _after_create_
  #
  # The method creates the community announcement space.
  ###
  def make_community_announcement_space
    if !self.community_announcement_space
      space = DiscussionSpace.new(:name => "Community Announcements")
      if space
        space.community = self
        space.is_announcement = true
        space.save!
        self.community_announcement_space = space
        self.save
      else
        logger.error("Could not create community announcement space for community #{self.to_yaml}")
      end
    end
  end
end


# == Schema Information
#
# Table name: communities
#
#  id                              :integer         not null, primary key
#  name                            :string(255)
#  slogan                          :string(255)
#  accepting_members               :boolean         default(TRUE)
#  email_notice_on_application     :boolean         default(TRUE)
#  subdomain                       :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  admin_profile_id                :integer
#  member_role_id                  :integer
#  protected_roster                :boolean         default(FALSE)
#  community_application_form_id   :integer
#  community_announcement_space_id :integer
#

