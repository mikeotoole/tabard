###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a community.
###
class Community < ActiveRecord::Base
  validates_lengths_from_database except: [:name, :slogan, :background_image]
  # Resource will be marked as deleted with the deleted_at column set to the time of deletion.
  acts_as_paranoid

  # This is a store used for the action items community setup bar.
  store :action_items, accessors: [ :update_home_page, :add_community_game, :update_settings, :update_application, :create_discussion_space ]

###
# Constants
###
  # Used by validators and view to restrict name length
  MAX_NAME_LENGTH = 25
  # Used by validators and view to restrict slogan length
  MAX_SLOGAN_LENGTH = 50
  # Used by validator to limit number of communities a user can own
  MAX_OWNED_COMMUNITIES = 20

# Attribute Accessors
  attr_accessor :new_community_plan_id

###
# Attribute accessible
###
  attr_accessible :name, :slogan, :is_accepting_members, :email_notice_on_application, :is_protected_roster, :is_public_roster, :theme_id, :theme,
    :background_color, :title_color, :background_image, :remove_background_image, :background_image_cache, :home_page_id

###
# Associations
###
  belongs_to :charge_exempt_authorizer, class_name: "AdminUser"

  belongs_to :admin_profile, class_name: "UserProfile"
  belongs_to :member_role, class_name: "Role"
  belongs_to :community_application_form, dependent: :destroy, class_name: "CustomForm", autosave: true

  has_many :community_applications, dependent: :destroy
  has_many :pending_applications, class_name: "CommunityApplication", conditions: {status: "Pending"}
  has_many :custom_forms, dependent: :delete_all, order: 'LOWER(name)', inverse_of: :community
  has_many :community_announcements, class_name: "Announcement", conditions: {community_game_id: nil}
  has_many :announcements
  has_many :community_invites, inverse_of: :community
  has_many :community_games, dependent: :destroy
  has_many :community_profiles, dependent: :destroy, inverse_of: :community
  has_many :approved_characters, through: :community_profiles
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

  # Plans and upgrades
  has_many :invoice_items, inverse_of: :community

  accepts_nested_attributes_for :theme

###
# Callbacks
###
  nilify_blanks only: [:slogan]
  before_create :update_subdomain
  before_create :setup_action_items
  after_create :setup_community_application_form
  after_create :setup_member_role, :make_admin_a_member
  after_create :setup_default_community_items
  after_destroy :destroy_admin_community_profile_and_member_role

###
# Delegates
###
  delegate :css, to: :theme, prefix: true
  delegate :background_author, to: :theme, prefix: true, allow_nil: true
  delegate :safe_background_author_url, to: :theme, prefix: true, allow_nil: true
  delegate :email, to: :admin_profile, prefix: true, allow_nil: true
  delegate :user, to: :admin_profile, prefix: true, allow_nil: true
  delegate :current_invoice, to: :admin_profile_user, allow_nil: true

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
  validates :admin_profile, presence: true
  validates :background_color, format: { with: /\A[0-9a-fA-F]{6}\Z/, message: "Only valid HEX colors are allowed." },
            unless: Proc.new{|community| community.background_color.blank? }
  validates :title_color, format: { with: /\A[0-9a-fA-F]{6}\Z/, message: "Only valid HEX colors are allowed." },
            unless: Proc.new{|community| community.title_color.blank? }
  validate :can_not_change_name, on: :update
  validate :within_owned_communities_limit, on: :create
  validate :home_page_owned_by_community
  validates :background_image,
      if: :background_image?,
      file_size: {
        maximum: 5.megabytes.to_i
      }
  validates :charge_exempt_authorizer, presence: true, if: Proc.new{|community| community.is_charge_exempt }
  validates :charge_exempt_start_time, presence: true, if: Proc.new{|community| community.is_charge_exempt }
  validates :charge_exempt_label, presence: true, if: Proc.new{|community| community.is_charge_exempt }
  validates :charge_exempt_reason, presence: true, if: Proc.new{|community| community.is_charge_exempt }
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
  #Toggles the charge exempt status of a community
  def toggle_charge_exempt_status(admin_user, label = nil, reason = nil)
    return false if admin_user.blank?
    if self.is_charge_exempt
      self.update_attributes({is_charge_exempt: false, charge_exempt_start_time: nil, charge_exempt_authorizer_id: nil, charge_exempt_label: label, charge_exempt_reason: reason}, without_protection: true)
    else
      self.update_attributes({is_charge_exempt: true, charge_exempt_start_time: DateTime.now, charge_exempt_authorizer_id: admin_user.id, charge_exempt_label: label, charge_exempt_reason: reason}, without_protection: true)
    end
  end

  # Returns all games that this community supports
  def games
    self.community_games.collect{|sg| sg.game}.uniq{|g| g.name}
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
# Invoice and Payment
###
  # If the community is disabled for not paying or being over capacity.
  def is_disabled?
    self.is_over_max_capacity? or not self.admin_profile.is_in_good_account_standing
  end

###
# Plan
###
  ###
  # The will return the communties current plan.
  #
  # OPTIMIZE: We may want to cache the current plan.
  ###
  def current_community_plan
    if @plan.blank?
      today = Time.now
      invoiceitem = self.invoice_items.where{(item_type == "CommunityPlan") & (start_date <= today) & (end_date >= today)}.limit(1).first
      @plan = invoiceitem.present? ? invoiceitem.item : CommunityPlan.default_plan
    end
    return @plan
  end

  # This will return the community plan set to be recurring.
  def recurring_community_plan
    self.current_invoice.plan_invoice_item_for_community(self).item
  end

  ###
  # Check if the current community is on a paid plan.
  # [Returns] True if not on the free plan.
  ###
  def is_paid_community?
    not self.current_community_plan.is_free_plan?
  end

  # This will return the current community plan title.
  def current_community_plan_title
    self.current_community_plan.title
  end

  # This will return the recurring community plan title.
  def recurring_community_plan_title
    self.recurring_community_plan.title
  end

  ###
  # This will save a community and adding the plan a user picks.
  # This is used when creating a new community.
  # # [Args]
  #   * +plan_id+ The plan id for the plan a user picks.
  #   * +stripe_card_token+ The token from stripe for their card.
  #   * +invoice+ The community owners invoice.
  # [Returns] True if community was created. Otherwise false is retuned and errors added to the communinty.
  ###
  def save_with_plan(plan_id, stripe_card_token, invoice)
    success = false
    plan = CommunityPlan.available.find_by_id(plan_id)
    plan = CommunityPlan.default_plan unless ENV["ENABLE_PAYMENT"]
    if plan.present?
      if invoice.present?
        Community.transaction do
          success = self.save
          if success and not plan.is_free_plan?
            invoice.invoice_items.new({community: self, item: plan, quantity: 1}, without_protection: true)
            unless invoice.update_attributes_with_payment(nil, stripe_card_token)
              self.errors[:base] = invoice.errors[:base].first
              success = false
              raise ActiveRecord::Rollback
            end
          end
        end
      else
        self.errors.add(:base, "current invoice not found. Please try again. If the issue continues open a support ticket.")
      end
    else
      self.errors.add(:base, "plan not found")
    end
    return success
  end

###
# Upgrades
###
  ###
  # This will return all of community upgrades for the community.
  ###
  def current_upgrades
    today = Time.now
    self.invoice_items.where{(item_type != "CommunityPlan") & (start_date <= today) & (end_date >= today)}
  end

###
# Members
###
  ###
  # The max number of users allowed in this community.
  # This includes plan and upgrade amounts.
  #
  # OPTIMIZE: We may want to cache max_number_of_users.
  ###
  def max_number_of_users
    if @total_max_user.blank?
      plan_users_total = self.current_community_plan.max_number_of_users
      user_pack_upgrades_ii = current_upgrades.joins{community_user_pack_items}
      upgrade_users_total = user_pack_upgrades_ii.map{|u| u.item.number_of_bonus_users * u.quantity}.inject(0,:+)
      @total_max_user = plan_users_total + upgrade_users_total
    end
    return @total_max_user
  end

  ###
  # The current number of community members.
  ###
  def current_number_of_users
    self.community_profiles_count
  end

  # If the community is over capacity.
  def is_over_max_capacity?
    self.current_number_of_users > self.max_number_of_users
  end

  # If the community is at max capacity.
  def is_at_max_capacity?
    self.current_number_of_users == self.max_number_of_users
  end

  # If the community is almost at max capacity.
  def is_at_almost_max_capacity?
    self.current_number_of_users >= self.max_number_of_users * 0.9 and self.current_number_of_users < self.max_number_of_users
  end

  # This will return a collection of community profiles ordered by the users display name.
  def ordered_community_profiles
    self.community_profiles.includes(:user_profile).order('LOWER(user_profiles.display_name)')
  end

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
  # [Returns] An array of characters, optionly filtered by game.
  ###
  def get_current_community_roster(game = nil)
    if game
      return self.approved_characters.reject{|character| character.game != game }
    else
      return self.approved_characters
    end
  end

  ###
  # This method gets the current members who have at least one character in the Community game.
  # [Args]
  #   * +community_game+ -> The supported game to use as a filter.
  # [Returns] An array of user_profiles, filtered by supported game.
  ###
  def member_profiles_for_community_game(community_game)
    self.approved_roster_assignments.includes(:user_profile).where(community_game_id: community_game.id).collect{|ra| ra.user_profile }.uniq.sort_by(&:display_name)
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
    name.downcase.gsub(/[^a-z]/,"")
  end

  ###
  # This method returns a search scoped or simply scoped search helper
  # [Args]
  #   * +search+ -> The string search for.
  # [Returns] A scoped query
  ###
  def self.search(search)
    if search
      community_ids = CommunityGame.search_by_game_name(search).pluck(:community_id)
      search = "%#{search}%"
      return where{(name =~ search) | (slogan =~ search) | (id.in(community_ids))}
    else
      return scoped
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
  ###
  def home_page_owned_by_community
    return unless home_page_id
    errors.add(:home_page_id, "is invalid. This page is owned by another community.") unless pages.include?(Page.find_by_id(home_page_id))
  end

###
# Callback Methods
###
  ###
  # _before_create_
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
                          add_community_game: true,
                          update_settings: true,
                          update_application: true,
                          create_discussion_space: true,
                          send_invites: true }
  end

  ###
  # _before_create_
  #
  # This method creates the community application form with some default questions.
  ###
  def setup_community_application_form
    ca = self.build_community_application_form(
      name: "Application Form",
      instructions: "You want to join us? Awesome! Please answer these short questions, and don't forget to let us know if someone recommended you.",
      thankyou: "Your submission has been sent. Thank you!",
      is_published: true,
      community: self)

    # First Question
    question1 = ca.questions.build(
      style: "select_box_question",
      body: "How often do you play each week?",
      is_required: true,
      position: 0)
    question1.predefined_answers.build(body: "1-3 hours", position: 0)
    question1.predefined_answers.build(body: "3-6 hours", position: 1)
    question1.predefined_answers.build(body: "6-10 hours", position: 2)
    question1.predefined_answers.build(body: "10-20 hours", position: 3)
    question1.predefined_answers.build(body: "20+ hours", position: 4)

    # Second Question
    question2 = ca.questions.build(
      style: "long_answer_question",
      body: "Why do you want to join?",
      explanation: "Let us know why we should game together.",
      is_required: true,
      position: 1)

    # Third Question
    question3 = ca.questions.build(
      style: "short_answer_question",
      body: "How did you hear about us?",
      explanation: "This is a short answer question",
      is_required: false,
      position: 2)
    ca.save!
    self.update_column :community_application_form_id, ca.id
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
    self.member_role.permissions.where(subject_class: "DiscussionSpace", id_of_subject: community_d_space.id).first.update_column(:permission_level, "View")
    self.member_role.permissions.where(subject_class: "Discussion", id_of_parent: community_d_space.id, parent_association_for_subject: "discussion_space").first.update_column(:can_create, true)
    self.update_column :theme_id, Theme.default_theme.id

    # Officer role
    #officer_role = self.roles.create!({name: "Officer", is_system_generated: false}, without_protection: true)
    #officer_role.permissions.create!({subject_class: "Announcement", permission_level: "Create", can_lock: true}, without_protection: true)
    #officer_role.permissions.create!({subject_class: "Comment", can_create: true, can_lock: true}, without_protection: true)
    #officer_role.permissions.create!({subject_class: "CommunityApplication", can_read: true}, without_protection: true)
    #officer_role.permissions.create!({subject_class: "CommunityInvite", can_create: true}, without_protection: true)
    #officer_role.permission_defaults.find_by_object_class("DiscussionSpace").update_attributes({permission_level: "View",
    #  can_lock: false,
    #  can_accept: false,
    #  can_read_nested: false,
    #  can_update_nested: false,
    #  can_create_nested: true,
    #  can_destroy_nested: true,
    #  can_lock_nested: true,
    #  can_accept_nested: false}, without_protection: true)
    #officer_role.permission_defaults.find_by_object_class("PageSpace").update_attributes({permission_level: "View",
    #  permission_level: "View",
    #  can_lock: false,
    #  can_accept: false}, without_protection: true)

    community_p_space = self.page_spaces.create!({name: I18n.t("community.default.page_space.name")}, without_protection: true)
    community_home_page = community_p_space.pages.create!({name: I18n.t("community.default.home_page.name"), markup: I18n.t("community.default.home_page.markup")}, without_protection: true)
    self.update_column :home_page_id, community_home_page.id
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
#  id                              :integer          not null, primary key
#  name                            :string(255)
#  slogan                          :string(255)
#  is_accepting_members            :boolean          default(TRUE)
#  email_notice_on_application     :boolean          default(TRUE)
#  subdomain                       :string(255)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  admin_profile_id                :integer
#  member_role_id                  :integer
#  is_protected_roster             :boolean          default(FALSE)
#  community_application_form_id   :integer
#  community_announcement_space_id :integer
#  is_public_roster                :boolean          default(TRUE)
#  deleted_at                      :datetime
#  background_image                :string(255)
#  background_color                :string(255)
#  theme_id                        :integer
#  title_color                     :string(255)
#  home_page_id                    :integer
#  pending_removal                 :boolean          default(FALSE)
#  action_items                    :text
#  community_plan_id               :integer
#  community_profiles_count        :integer          default(0)
#  is_charge_exempt                :boolean          default(FALSE)
#  charge_exempt_authorizer_id     :integer
#  charge_exempt_start_time        :datetime
#  charge_exempt_label             :string(255)
#  charge_exempt_reason            :text
#

