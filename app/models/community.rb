###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community.
###
class Community < ActiveRecord::Base
# TODO email_notice_on_application attribute needs to be talked about and reevaluated. -MO

###
# Attribute accessible
###
  attr_accessible :name, :slogan, :is_accepting_members, :email_notice_on_application, :is_protected_roster, :is_public_roster

###
# Associations
###
  belongs_to :admin_profile, :class_name => "UserProfile"
  belongs_to :member_role, :class_name => "Role"
  belongs_to :community_application_form, :dependent => :destroy, :class_name => "CustomForm"
  has_many :community_applications, :dependent => :destroy
  has_many :pending_applications, :class_name => "CommunityApplication", :conditions => {:status => "Pending"}
  has_many :roles, :dependent => :destroy

  has_many :supported_games, :dependent => :destroy
  has_many :game_announcement_spaces, :through => :supported_games

  has_many :custom_forms, :dependent => :destroy
  has_many :community_profiles
  has_many :member_profiles, :through => :community_profiles, :class_name => "UserProfile", :source => "user_profile"
  has_many :roster_assignments, :through => :community_profiles
  has_many :pending_roster_assignments, :through => :community_profiles
  has_many :discussion_spaces, :class_name => "DiscussionSpace", :conditions => {:is_announcement_space => false}, :dependent => :destroy
  has_many :announcement_spaces, :class_name => "DiscussionSpace", :conditions => {:is_announcement_space => true}, :dependent => :destroy
  belongs_to :community_announcement_space, :class_name => "DiscussionSpace", :dependent => :destroy
  has_many :discussions, :through => :discussion_spaces
  has_many :comments
  has_many :page_spaces, :dependent => :destroy
  has_many :pages, :through => :page_spaces

###
# Callbacks
###
  before_save :update_subdomain
  after_create :setup_member_role, :make_admin_a_member, :setup_community_application_form, :make_community_announcement_space, :setup_default_community_items

###
# Validators
###
  validates :name,  :presence => true,
                    :uniqueness => { :case_sensitive => false },
                    :format => { :with => /\A[a-zA-Z0-9 \-]+\z/, :message => "Only letters, numbers, dashes and spaces are allowed" }
  validates :name, :community_name => true, :on => :create
  validates :name, :not_profanity => true
  validates :name, :not_restricted_name => {:all => true}
  validate :can_not_change_name, :on => :update
  validates :admin_profile, :presence => true

###
# Public Methods
###

  ###
  # This method checks if a given user can apply to the community
  # [Args]
  #   * +user+ The user to check
  # [Returns] True if the community can receive an application from the user, false otherwise
  def can_receive_application_from?(user)
    if user
      self.is_accepting_members and !user.is_member? self and !user.application_pending? self
    else
      true
    end
  end

###
# Instance Methods
###


  def games
    self.supported_games.collect { |a| a.game }
  end

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
    mr = self.build_member_role(:name => "Member", :is_system_generated => true)
    mr.community = self
    mr.save
    self.update_attribute(:member_role, mr)
  end

  ###
  # _after_create_
  #
  # This method creates the community application form with some default questions.
  ###
  def setup_community_application_form
    ca = self.build_community_application_form(
      :name => "Application Form",
      :instructions => "You want to join us? Awesome! Please answer these short questions, and don't forget to let us know if someone recommended you.",
      :thankyou => "Your submission has been sent. Thank you!",
      :is_published => true)
    ca.community = self

    # First Question
    question = SingleSelectQuestion.create(
      :style => "select_box_question",
      :body => "How often do you play?",
      :is_required => true)
    question.custom_form = ca
    question.save
    PredefinedAnswer.create(:body => "1-3 hours", :select_question_id => question.id)
    PredefinedAnswer.create(:body => "3-6 hours", :select_question_id => question.id)
    PredefinedAnswer.create(:body => "6-10 hours", :select_question_id => question.id)
    PredefinedAnswer.create(:body => "10-20 hours", :select_question_id => question.id)
    PredefinedAnswer.create(:body => "20+ hours", :select_question_id => question.id)

    # Second Question
    question = TextQuestion.create(
      :style => "long_answer_question",
      :body => "Why do you want to join?",
      :explanation => "Let us know why we should game together.",
      :is_required => true)
    question.custom_form = ca
    question.save

    # Third Question
    question = TextQuestion.create(
      :style => "short_answer_question",
      :body => "How did you hear about us?",
      :explanation => "This is a short answer question",
      :is_required => false)
    question.custom_form = ca
    question.save

    ca.save
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
        space.is_announcement_space = true
        space.save!
        self.community_announcement_space = space
        self.save
      else
        logger.error("Could not create community announcement space for community #{self.to_yaml}")
      end
    end
  end

  ###
  # _after_create_
  #
  # The method creates a default community discussion space
  ###
  def setup_default_community_items
    community_d_space = self.discussion_spaces.create(name: "Community")

    # Member role
    self.member_role.permissions.create(subject_class: "Comment", permission_level: "Delete")
    # Officer role
    officer_role = self.roles.create(:name => "Officer", :is_system_generated => false)
    officer_role.permissions.create(subject_class: "Comment", permission_level: "Delete", can_lock: true)
    officer_role.permissions.create(subject_class: "CommunityApplication", permission_level: "View")

    # Discussions
    self.discussion_spaces.each do |space|
      self.member_role.permissions.create(subject_class: "DiscussionSpace", id_of_subject: space.id, permission_level: "View")
      self.member_role.permissions.create(subject_class: "Discussion", parent_association_for_subject: "discussion_space", id_of_parent: space.id, permission_level: "Delete")
      officer_role.permissions.create(subject_class: "DiscussionSpace", id_of_subject: space.id, permission_level: "View")
      officer_role.permissions.create(subject_class: "Discussion", parent_association_for_subject: "discussion_space", id_of_parent: space.id, permission_level: "Delete", can_lock: true)
    end
    # Pages
    self.page_spaces.each do |space|
      self.member_role.permissions.create(subject_class: "PageSpace", id_of_subject: space.id, permission_level: "View")
      self.member_role.permissions.create(subject_class: "Page", parent_association_for_subject: "page_space", id_of_parent: space.id, permission_level: "View")
      officer_role.permissions.create(subject_class: "PageSpace", id_of_subject: space.id, permission_level: "View")
      officer_role.permissions.create(subject_class: "Page", parent_association_for_subject: "page_space", id_of_parent: space.id, permission_level: "Delete")
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
#  is_accepting_members            :boolean         default(TRUE)
#  email_notice_on_application     :boolean         default(TRUE)
#  subdomain                       :string(255)
#  created_at                      :datetime
#  updated_at                      :datetime
#  admin_profile_id                :integer
#  member_role_id                  :integer
#  is_protected_roster             :boolean         default(FALSE)
#  community_application_form_id   :integer
#  community_announcement_space_id :integer
#  is_public_roster                :boolean         default(TRUE)
#

