###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community.
###
class Community < ActiveRecord::Base
  validates_lengths_from_database except: [:name, :slogan, :pitch]
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

  # This is a store used for the action items community setup bar.
  store :action_items, accessors: [ :update_home_page, :add_supported_game, :update_settings, :update_application, :create_discussion_space ]

###
# Constants
###
  # Used by validators and view to restrict name length
  MAX_NAME_LENGTH = 25
  # Used by validators and view to restrict slogan length
  MAX_SLOGAN_LENGTH = 50
  # Used by validator to limit number of communities a user can own
  MAX_OWNED_COMMUNITIES = 3
  # Used by validator to limit restrict pitch length
  MAX_PITCH_LENGTH = 100

###
# Attribute accessible
###
  attr_accessible :name, :slogan, :is_accepting_members, :email_notice_on_application, :is_protected_roster, :is_public_roster, :theme_id, :theme,
    :background_color, :title_color, :background_image, :remove_background_image, :background_image_cache, :home_page_id, :pitch

###
# Associations
###
  belongs_to :admin_profile, class_name: "UserProfile"
  belongs_to :member_role, class_name: "Role"
  belongs_to :community_application_form, dependent: :destroy, class_name: "CustomForm"
  has_many :community_applications, dependent: :destroy
  has_many :pending_applications, class_name: "CommunityApplication", conditions: {status: "Pending"}
  has_many :custom_forms, dependent: :destroy, order: 'LOWER(name)'
  has_many :community_announcements, class_name: "Announcement", conditions: {supported_game_id: nil}
  has_many :announcements
  has_many :supported_games, dependent: :destroy
  has_many :community_profiles, dependent: :destroy, inverse_of: :community
  has_many :approved_character_proxies, through: :community_profiles
  has_many :member_profiles, through: :community_profiles, class_name: "UserProfile", source: "user_profile", order: 'LOWER(user_profiles.display_name)'
  has_many :roster_assignments, through: :community_profiles
  has_many :pending_roster_assignments, through: :community_profiles
  has_many :approved_roster_assignments, through: :community_profiles
  has_many :roles, dependent: :destroy, order: :id
  has_many :discussion_spaces, class_name: "DiscussionSpace", dependent: :destroy, order: 'LOWER(name)'
  has_many :discussions, through: :discussion_spaces
  has_many :comments
  has_many :page_spaces, dependent: :destroy, order: 'LOWER(name)'
  has_many :pages, through: :page_spaces
  has_many :activities, dependent: :destroy, inverse_of: :community
  has_many :events, dependent: :destroy
  belongs_to :theme
  belongs_to :home_page, class_name: "Page"

  accepts_nested_attributes_for :theme

###
# Callbacks
###
  nilify_blanks only: [:pitch, :slogan]
  before_save :update_subdomain
  before_create :setup_action_items
  after_create :setup_member_role, :make_admin_a_member, :setup_community_application_form, :setup_default_community_items
  after_destroy :destroy_admin_community_profile_and_member_role

###
# Delegates
###
  delegate :css, to: :theme, prefix: true
  delegate :background_author, to: :theme, prefix: true, allow_nil: true
  delegate :background_author_url, to: :theme, prefix: true, allow_nil: true

###
# Validators
###
  validates :name,  presence: true,
                    format: { with: /\A[a-zA-Z0-9 \-]+\z/, message: "Only letters, numbers, dashes and spaces are allowed" },
                    length: { maximum: MAX_NAME_LENGTH }
  validates :name, community_name: true, on: :create
  validates :name, not_profanity: true
  validates :name, not_restricted_name: {all: true}
  validates :slogan, length: { maximum: MAX_SLOGAN_LENGTH }
  validates :pitch, length: { maximum: MAX_PITCH_LENGTH }
  validates :admin_profile, presence: true
  validates :background_color, format: { with: /^[0-9a-fA-F]{6}$/, message: "Only valid HEX colors are allowed." },
            unless: Proc.new{|community| community.background_color.blank? }
  validates :title_color, format: { with: /^[0-9a-fA-F]{6}$/, message: "Only valid HEX colors are allowed." },
            unless: Proc.new{|community| community.title_color.blank? }
  validate :can_not_change_name, on: :update
  validate :within_owned_communities_limit, on: :create
  validate :home_page_owned_by_community
  validates :background_image,
      if: :background_image?,
      file_size: {
        maximum: 5.megabytes.to_i
      }
###
# Uploaders
###
  mount_uploader :background_image, BackgroundImageUploader

###
# Public Methods
###

###
# Class Methods
###
  # This is a class method to destory a community. This should be called using delay job and should be the only way communities are destroyed.
  def self.destory_community(id)
    community = Community.find(id)
    community.community_profiles.destroy_all # First remove all community profiles so no user has permissions.
    community.destroy
  end

###
# Instance Methods
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
  # Returns all games that this community supports
  def games
    self.supported_games.collect { |a| a.game }
  end

  # This will return a collection of community profiles ordered by the users display name.
  def ordered_community_profiles
    self.community_profiles.includes(:user_profile).order('LOWER(user_profiles.display_name)')
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
    community_profile = self.community_profiles.find_by_user_profile_id(user_profile.id)
    if not community_profile
      community_profile = user_profile.community_profiles.create!({community: self, roles: [self.member_role]}, without_protection: true)
    end
    return community_profile
  end

  ###
  # This method gets the current communtiy roster. An option game may be specified.
  # [Args]
  #   * +game+ -> The user profile you would like to promote to a member.
  # [Returns] An array of character_proxies, optionly filtered by game.
  ###
  def get_current_community_roster(game = nil)
    if game
      return self.approved_character_proxies.reject{|cp| cp.game != game }
    else
      return self.approved_character_proxies
    end
  end

  ###
  # This method gets the current members who have at least one character in the supported game.
  # [Args]
  #   * +supported_game+ -> The supported game to use as a filter.
  # [Returns] An array of user_profiles, filtered by supported game.
  ###
  def member_profiles_for_supported_game(supported_game)
    self.approved_roster_assignments.includes(:user_profile).where(supported_game_id: supported_game.id).collect{|ra| ra.user_profile }.uniq.sort_by(&:display_name)
  end

  ###
  # This method attempts to apply default permissions for an item by calling apply_default_permissions for each role in the community.
  # [Args]
  #   * +some_thing+ -> The object to apply default permissions on.
  ###
  def apply_default_permissions(some_thing)
    self.roles.each do |role|
      role.apply_default_permissions(some_thing)
    end
  end

  # This will force community and its comments and discussions to be fully removed.
  def nuke
    self.community_applications.each{|application| application.comments.each{|comment| comment.nuke}}
    self.discussions.each{|discussion| discussion.nuke}
    self.destroy!
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
  # This method returns a search scoped or simply scoped search helper
  # [Args]
  #   * +search+ -> The string search for.
  # [Returns] A scoped query
  ###
  def self.search(search)
    if search
      search = "%"+search+'%'
      where{(name =~ search) | (slogan =~ search) | (pitch =~ search)}
    else
      scoped
    end
  end

###
# Validator Methods
###
  ###
  # _validator_
  #
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
  # _validator_
  #
  # This will check that the admin is within the limit of maximum owned communities allowed.
  ###
  def within_owned_communities_limit
    if admin_profile and admin_profile.owned_communities.size >= MAX_OWNED_COMMUNITIES #and not admin_profile.owned_communities.include?(self)
      errors.add(:base, "Too many communities! You can only administer #{Community::MAX_OWNED_COMMUNITIES} communities at a time.")
    end
  end

  ###
  # _validator_
  #
  # This will check that the home page is owned by the community.
  def home_page_owned_by_community
    return unless home_page_id
    errors.add(:home_page_id, "is invalid. This page is owned by another community.") unless pages.include?(Page.find_by_id(home_page_id))
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
    mr = self.build_member_role({name: "Member", is_system_generated: true}, without_protection: true)
    mr.community = self
    mr.save!
    self.update_column(:member_role_id, mr.id)
  end

  ###
  # _before_create_
  #
  # This method sets all action items as not complete.
  ###
  def setup_action_items
    self.action_items = { update_home_page: true,
                          add_supported_game: true,
                          update_settings: true,
                          update_application: true,
                          create_discussion_space: true }
  end

  ###
  # _after_create_
  #
  # This method creates the community application form with some default questions.
  ###
  def setup_community_application_form
    ca = self.build_community_application_form(
      name: "Application Form",
      instructions: "You want to join us? Awesome! Please answer these short questions, and don't forget to let us know if someone recommended you.",
      thankyou: "Your submission has been sent. Thank you!",
      is_published: true)
    ca.community = self

    # First Question
    question = Question.create!(
      style: "select_box_question",
      body: "How often do you play each week?",
      is_required: true,
      position: 0)
    question.custom_form = ca
    question.save!
    PredefinedAnswer.create!(body: "1-3 hours", question_id: question.id, position: 0)
    PredefinedAnswer.create!(body: "3-6 hours", question_id: question.id, position: 1)
    PredefinedAnswer.create!(body: "6-10 hours", question_id: question.id, position: 2)
    PredefinedAnswer.create!(body: "10-20 hours", question_id: question.id, position: 3)
    PredefinedAnswer.create!(body: "20+ hours", question_id: question.id, position: 4)

    # Second Question
    question = Question.create!(
      style: "long_answer_question",
      body: "Why do you want to join?",
      explanation: "Let us know why we should game together.",
      is_required: true,
      position: 1)
    question.custom_form = ca
    question.save!

    # Third Question
    question = Question.create!(
      style: "short_answer_question",
      body: "How did you hear about us?",
      explanation: "This is a short answer question",
      is_required: false,
      position: 2)
    question.custom_form = ca
    question.save!

    ca.save!
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
  # The method creates a default community discussion space
  ###
  def setup_default_community_items
    community_d_space = self.discussion_spaces.create!(name: "Community")

    # Member role
    self.member_role.permissions.create!({subject_class: "Comment", can_create: true}, without_protection: true)
    self.member_role.permissions.create!({subject_class: "DiscussionSpace", permission_level: "View", id_of_subject: community_d_space.id}, without_protection: true)
    self.member_role.permissions.create!({subject_class: "Discussion", can_create: true, id_of_parent: community_d_space.id, parent_association_for_subject: "discussion_space"}, without_protection: true)
    self.update_column(:theme_id, Theme.default_theme.id)

    # Officer role
    officer_role = self.roles.create!({name: "Officer", is_system_generated: false}, without_protection: true)
    officer_role.permissions.create!({subject_class: "Announcement", permission_level: "Create", can_lock: true}, without_protection: true)
    officer_role.permissions.create!({subject_class: "Comment", can_create: true, can_lock: true}, without_protection: true)
    officer_role.permissions.create!({subject_class: "CommunityApplication", can_read: true}, without_protection: true)
    officer_role.permission_defaults.find_by_object_class("DiscussionSpace").update_attributes({permission_level: "View",
      can_lock: false,
      can_accept: false,
      can_read_nested: false,
      can_update_nested: false,
      can_create_nested: true,
      can_destroy_nested: true,
      can_lock_nested: true,
      can_accept_nested: false}, without_protection: true)
    officer_role.permission_defaults.find_by_object_class("PageSpace").update_attributes({permission_level: "View",
      permission_level: "View",
      can_lock: false,
      can_accept: false}, without_protection: true)

    community_p_space = self.page_spaces.create!({name: I18n.t("community.default.page_space.name")}, without_protection: true)
    community_home_page = community_p_space.pages.create!({name: I18n.t("community.default.home_page.name"), markup: I18n.t("community.default.home_page.markup")}, without_protection: true)
    self.update_attributes home_page_id: community_home_page.id
  end

  ###
  # _after_destroy_
  #
  # The method will destory the admin_community_profile and member role. This is necessary becouse of the community_profile validators.
  ###
  def destroy_admin_community_profile_and_member_role
    roles = Role.where(community_id: self.id)
    admin_community_profile = self.community_profiles.where(user_profile_id: self.admin_profile.id).first
    if Community.with_deleted.exists?(self)
      admin_community_profile.destroy if admin_community_profile
      roles.each do |role|
        role.destroy
      end
    else
      admin_community_profile.destroy! if admin_community_profile
      roles.each do |role|
        role.destroy!
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
#  is_accepting_members            :boolean         default(TRUE)
#  email_notice_on_application     :boolean         default(TRUE)
#  subdomain                       :string(255)
#  created_at                      :datetime        not null
#  updated_at                      :datetime        not null
#  admin_profile_id                :integer
#  member_role_id                  :integer
#  is_protected_roster             :boolean         default(FALSE)
#  community_application_form_id   :integer
#  community_announcement_space_id :integer
#  is_public_roster                :boolean         default(TRUE)
#  deleted_at                      :datetime
#  background_image                :string(255)
#  background_color                :string(255)
#  theme_id                        :integer
#  title_color                     :string(255)
#  home_page_id                    :integer
#  pending_removal                 :boolean         default(FALSE)
#  action_items                    :text
#  pitch                           :string(255)
#

