###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a user's profile.
###
class UserProfile < ActiveRecord::Base
  validates_lengths_from_database except: [:gamer_tag, :name, :full_name, :title, :location, :description, :avatar]
###
# Constants
###
  # Max gamer_tag length
  MAX_GAMER_TAG_LENGTH = 15
  # Max name length
  MAX_NAME_LENGTH = 30
  # Max full name length
  MAX_FULL_NAME_LENGTH = 80
  # Max title length
  MAX_TITLE_LENGTH = 30
  # Max location length
  MAX_LOCATION_LENGTH = 30
  # Max description length
  MAX_DESCRIPTION_LENGTH = 500

###
# Attribute accessible
###
  attr_accessible :gamer_tag, :full_name, :display_name, :title, :publicly_viewable,
      :avatar, :remove_avatar, :remote_avatar_url, :description, :location

###
# Friendly ID
###
  extend FriendlyId
  friendly_id :gamer_tag, use: :slugged

###
# Associations
###
  has_one :user, inverse_of: :user_profile

  has_many :owned_communities, class_name: "Community", foreign_key: "admin_profile_id", dependent: :destroy
  has_many :community_profiles, dependent: :destroy
  has_many :related_community_profiles, through: :communities, source: :community_profiles, readonly: true
  has_many :related_user_profiles, through: :related_community_profiles, source: :user_profile, uniq: true, readonly: true

  has_many :roles, through: :community_profiles
  has_many :community_invite_applications, class_name: "CommunityInvite", foreign_key: "applicant_id", inverse_of: :applicant, dependent: :destroy
  has_many :invited_to_communities, through: :community_invite_applications, class_name: "Community", source: :community
  has_many :community_invite_sponsors, class_name: "CommunityInvite", foreign_key: "sponsor_id", inverse_of: :sponsor, dependent: :destroy

#Games
  has_many :played_games, dependent: :destroy
  has_many :characters, through: :played_games
  has_many :games, through: :played_games

  has_many :approved_characters, through: :community_profiles
  has_many :communities, through: :community_profiles, order: 'LOWER(name)'
  has_many :announcements, through: :community_profiles
  has_many :acknowledgements, through: :community_profiles
  has_many :read_announcements, through: :community_profiles
  has_many :unread_announcements, through: :community_profiles
  has_many :community_applications, dependent: :destroy
  has_many :view_logs, dependent: :destroy
  has_many :sent_messages, class_name: "Message", foreign_key: "author_id", dependent: :destroy
  has_many :received_messages, class_name: "MessageAssociation", foreign_key: "recipient_id", dependent: :destroy
  has_many :unread_messages, class_name: "MessageAssociation", foreign_key: "recipient_id", conditions: {has_been_read: false, is_removed: false}
  has_many :folders, dependent: :destroy
  has_many :discussions, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy, inverse_of: :user_profile
  has_many :events, dependent: :destroy, foreign_key: "creator_id"
  has_many :invites, dependent: :destroy, inverse_of: :user_profile
  has_many :events_invited_to, through: :invites, source: :event, class_name: "Event"

  has_many :support_tickets, inverse_of: :user_profile
  has_many :pending_support_tickets, class_name: "SupportTicket", conditions: {status: SupportTicket::DEFAULT_STATUS}
  has_many :in_progress_support_tickets, class_name: "SupportTicket", conditions: {status: "In Progress"}
  has_many :closed_support_tickets, class_name: "SupportTicket", conditions: {status: "Closed"}

  has_many :support_comments, inverse_of: :user_profile

###
# Delegates
###
  delegate :email, to: :user, allow_nil: true
  delegate :is_disabled?, to: :user
  delegate :is_email_on_message, to: :user
  delegate :is_email_on_announcement, to: :user
  delegate :is_email_on_invite, to: :user
  delegate :current_invoice, to: :user
  delegate :is_in_good_account_standing, to: :user

###
# Callbacks
###
  nilify_blanks only: [:full_name, :description, :title, :location]
  before_validation :set_display_name_if_nil
  after_create :create_mailboxes
  after_create :check_for_invites

###
# Scopes
###
  scope :active, lambda {
    includes(:user).joins{:user}.where{(user.admin_disabled_at == nil) & (user.user_disabled_at == nil)}
  }

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# Validators
###
  validates :gamer_tag,
      presence: true,
      uniqueness: { case_sensitive: false },
      length: { maximum: MAX_GAMER_TAG_LENGTH },
      format: { with: %r{\A[a-z0-9]+\Z}i }
  validates :display_name, presence: true, length: { maximum: MAX_NAME_LENGTH }
  validates :full_name, presence: true, length: { maximum: MAX_FULL_NAME_LENGTH }
  validates :title, length: { maximum: MAX_TITLE_LENGTH }
  validates :location, length: { maximum: MAX_LOCATION_LENGTH }
  validates :description, length: { maximum: MAX_DESCRIPTION_LENGTH }
  validates :display_name, not_restricted_name: {domain: false, company: true, administration: true}
  validates :avatar,
      if: :avatar?,
      file_size: {
        maximum: 5.megabytes.to_i
      }

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method creates a string of the users first and last name as one string.
  # [Returns] A string containing the users first and last name.
  ###
  def name
    self.display_name
  end

  ###
  # This method will return a cancan ability with the passed community's dynamic rules added in.
  # [Args]
  #   * +context_community+ -> The community to scope the ability with.
  # [Returns] A CanCan ability with the community scope.
  ###
  def in_community(context_community)
    return Ability.new unless self.user
    return Ability.new(self.user) unless context_community
    context_ability = Ability.new(self.user)
    context_ability.dynamicContextRules(self.user, context_community)
    return context_ability
  end

  ###
  # This method gets all of characters that are compatable with the communities Community games.
  # [Returns] An array that contains all of the compatable character proxies.
  ###
  def compatable_characters(community)
    self.characters.reject{|character| !character.compatable_with_community?(community)}
  end

  ###
  # This method gets all of the avaliable characters attached to this user profile.
  # [Returns] An array that contains all of the avalible characters attached to this user profile.
  ###
  def available_characters(community, game = nil)
    return self.characters unless community
    available_characters = Array.new
    community_profile = self.community_profiles.where{community_id == community.id}.first
    available_characters.concat community_profile.approved_characters if community_profile
    if game
      if game.class == CommunityGame
        available_characters = available_characters.delete_if{|character| character.game.class.to_s != game.game.class.to_s}
      else
        available_characters = available_characters.delete_if{|character| character.game.class.to_s != game.class.to_s}
      end
    end
    available_characters
  end

  # This method attepts to add the specified role to the correct community profile of this user, if the user has a community profile that matches the role's community.
  def add_new_role(role)
    correct_community_profile = self.community_profiles.find_by_community_id(role.community_id)
    if correct_community_profile
      correct_community_profile.roles << role
      return true
    end
    return false
  end

  # This method attepts to remove the specified role to the correct community profile of this user, if the user has a community profile that matches the role's community.
  def remove_role(role)
    correct_community_profile = self.community_profiles.find_by_community_id(role.community_id)
    if correct_community_profile
      correct_community_profile.roles.delete(role)
      return true
    end
    return false
  end

  ###
  # This method checks if the user is a member of the given community.
  # [Args]
  #   * +community+ The community to check membership of.
  # [Returns] True if member of the community false otherwise.
  def is_member?(community)
    if community
     self.roles.map{|r| r.id}.include?(community.member_role_id)
    else
     false
    end
  end

  # This gets the total price for the specified community.
  def total_price_per_month_in_cents(community)
    self.user.total_price_per_month_in_cents(community)
  end

  # Returns true if user is invited to event false otherwise.
  def invited?(event)
    self.invites.where(event_id: event.id).size > 0
  end

  ###
  # This method checks if the user has a pending application with the community.
  # [Args]
  #   * +some_community+ The community to check membership of.
  # [Returns] True if has pending application of the community, false otherwise.
  def application_pending?(community)
    if community
     self.community_applications.where{(community_id == community.id) & (status == "Pending")}.exists?
    else
     false
    end
  end

  ###
  # This method determines when this user joined a community
  # [Args]
  #   * +community+ The community to check.
  # [Returns] nil if this user is not a member of the community, otherwise it will return the join date of the user.
  def joined_community_on(community)
    if self.is_member?(community)
      return self.community_profiles.find_by_community_id(community).created_at
    else
      return nil
    end
  end

  ###
  # This method checks if a user profile has viewed a view-loggable object or not. If no user is specified, current user's user profile will be used.
  # [Args]
  #   * +view_loggable_item+ -> The view-loggable object to check.
  # [Returns] True if the specified user is the owner of this character, otherwise false.
  def has_seen?(view_loggable_item)
    if view_loggable_item.class == ViewLog
      user_id = self.id
      return ViewLog.where{(
        (view_loggable_id.eq view_loggable_item.id) &
        (view_loggable_type.eq view_loggable_item.class.to_s) &
        (user_profile_id.eq user_id)
      )}.exists?
    end
    if view_loggable_item.class == Announcement
      return self.read_announcements.include?(view_loggable_item)
    end
    return false
  end

  ###
  # This method logs the viewing of the given loggable item by the current user a the current time.
  # [Args]
  #   * +view_loggable_item+ -> The view-loggable object to log as viewed.
  def update_viewed(view_loggable_item)
    log = self.view_logs.find_by_view_loggable_id_and_view_loggable_type(view_loggable_item.id, view_loggable_item.class.to_s)
    if log
      log.touch
    else
      log = self.view_logs.new()
      log.user_profile = self
      log.view_loggable = view_loggable_item
      log.save
    end
  end

  ###
  # This method checks to see if the specified user is the owner of this character.
  # [Args]
  #   * +unknown_user+ -> The user to check.
  # [Returns] True if the specified user is the owner of this character, otherwise false.
  ###
  def owned_by_user?(unknown_user)
    self.user.id == unknown_user.id
  end

  ###
  # This method gets an array of possible active profile options.
  # [Returns] An array that user profile + all of their characters.
  ###
  def active_profile_helper_collection(community, game)
    if community
      return (Array.new() << (self)).concat(self.available_characters(community,game))
    else
      return (Array.new() << (self)).concat(self.characters)
    end
  end

  ###
  # This method gets an array of possible active profile options.
  # [Returns] An activerecord collection that user profile.
  ###
  def address_book
    my_id = self.id
    related_user_profiles.where{id != my_id}
  end

  ###
  # This method gets the user's messages inbox folder.
  # [Returns] Folder of users inbox
  ###
  def inbox
    folders.find_by_name("Inbox")
  end

  ###
  # This method gets the user's messages trash folder.
  # [Returns] Folder of users trash.
  ###
  def trash
    folders.find_by_name("Trash")
  end

  # This will remove this user profile's avatar and all character's avatars.
  def remove_all_avatars
    self.remove_avatar!
    self.update_column(:avatar, nil)
    self.characters.each do |character|
      character.remove_avatar!
      character.update_column(:avatar, nil)
    end
  end

  # This will destroy forever this user profile and all its associated resources.
  def nuke
    self.characters.each{|character| character.delete}

    self.owned_communities.each{|community| community.nuke}
    self.community_profiles.each{|community_profile| community_profile.destroy!}
    self.view_logs.each{|view_log| view_log.destroy!}
    self.community_applications.each{|application| application.destroy!}

    self.discussions.each{|discussion| discussion.nuke}
    self.comments.each{|comment| comment.nuke}
  end

###
# Protected Methods
###
protected

###
# Instance Methods
###
  ###
  # This method is added for removing an avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
  ###
  def remove_avatar!
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
    end
  end

  ###
  # This method is added for removing a previously stored avatar. Code snippet I found on the internet to prevent noisy file not found errors. -JW
  ###
  def remove_previously_stored_avatar
    begin
      super
    rescue Fog::Storage::Rackspace::NotFound
      @previous_model_for_avatar = nil
    end
  end

###
# Class Methods
###
  ###
  # This method returns a search scoped or simply scoped search helper
  # [Args]
  #   * +search+ -> The string search for.
  # [Returns] A scoped query
  ###
  def self.search(search)
    if search
      search = "%"+search+'%'
      where{((display_name =~ search) | (gamer_tag =~ search))}
    else
      scoped
    end
  end

###
# Callback Methods
###

  def set_display_name_if_nil
    self.display_name = self.gamer_tag if self.display_name.blank?
  end

  ###
  # _after_create_
  #
  # This method creates the user's inbox folder.
  ###
  def create_mailboxes
    self.folders.create!(name: "Inbox")
    self.folders.create!(name: "Trash")
  end

  ###
  # _after_create_
  #
  # This method looks for CommunityInvites for this user and sends them a system message.
  ###
  def check_for_invites
    CommunityInvite.where(email: self.email).each do |invite|
      invite.update_attributes(applicant: self)
    end
  end
end

# == Schema Information
#
# Table name: user_profiles
#
#  id                :integer          not null, primary key
#  avatar            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  description       :text
#  display_name      :string(255)
#  publicly_viewable :boolean          default(TRUE)
#  title             :string(255)
#  location          :string(255)
#  full_name         :string(255)
#  gamer_tag         :string(255)
#  slug              :string(255)
#

