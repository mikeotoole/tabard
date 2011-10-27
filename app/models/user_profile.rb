###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a user's profile.
###
class UserProfile < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :first_name, :last_name, :display_name,
      :avatar, :remote_avatar_url, :remove_avatar, :avatar_cache

###
# Associations
###
  belongs_to :user, :inverse_of => :user_profile
  has_many :owned_communities, :class_name => "Community", :foreign_key => "admin_profile_id"
  has_many :community_profiles, :dependent => :destroy
  has_many :character_proxies, :dependent => :destroy
  has_many :approved_character_proxies, :through => :community_profiles
  has_many :communities, :through => :community_profiles
  has_many :announcement_spaces, :through => :communities
  has_many :announcements, :through => :announcement_spaces, :class_name => "Discussion", :source => "discussions"
  has_many :community_applications
  has_many :view_logs, :dependent => :destroy
  has_many :sent_messages, :class_name => "Message", :foreign_key => "author_id", :dependent => :destroy
  has_many :received_messages, :class_name => "MessageAssociation", :foreign_key => "recipient_id", :dependent => :destroy
  has_many :unread_messages, :class_name => "MessageAssociation", :foreign_key => "recipient_id", :conditions => {:has_been_read => false, :deleted => false}, :dependent => :destroy
  has_many :folders, :dependent => :destroy

###
# Delegates
###
  delegate :email, :to => :user

###
# Callbacks
###
  before_create :build_mailboxes

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# Validators
###
  validates :display_name, :presence => true, :uniqueness => true
  validates :user, :presence => true
  validates :avatar,
      :if => :avatar?,
      :file_size => {
        :maximum => 1.megabytes.to_i
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
  # This method gets all of the characters attached to this user profile.
  # [Returns] An array that contains all of the characters attached to this user profile.
  ###
  def characters
    characters = Array.new()
    for proxy in self.character_proxies
        characters << proxy.character
    end
    characters
  end

  ###
  # This method gets all of the avaliable characters attached to this user profile.
  # [Returns] An array that contains all of the avalible characters attached to this user profile.
  ###
  def available_character_proxies(community, game = nil)
    available_character_proxies = Array.new
    community_profile = self.community_profiles.where{:communtiy == community}.first
    available_character_proxies.concat community_profile.approved_character_proxies if community_profile
    available_character_proxies = available_character_proxies.delete_if{|proxy| proxy.game != game} if game
    available_character_proxies
  end

  ###
  # This method will return all of the character proxies for this user profile who's character matches the specified game.
  # [Args]
  #   * +game+ -> The game to scope the proxies by.
  # [Returns] An array that contains all of this user profiles character proxies who's character matches the specified game.
  ###
  def character_proxies_for_a_game(game)
    # OPTIMIZE Joe At some point benchmark this potential hot spot search. We may want to add game_id to character proxies if this is too slow. -JW
    # FIXME Joe, WTF! Associations why you no work!
    proxies = CharacterProxy.where(:user_profile_id => self.id)

    proxies.delete_if { |proxy| (proxy.game.id != game.id) }
  end

  ###
  # This method will return all of the character proxies for this user profile who's character matches the specified game.
  # [Args]
  #   * +game+ -> The game to scope the proxies by.
  # [Returns] An array that contains all of this user profiles character proxies who's character matches the specified game.
  ###
  def default_character_proxy_for_a_game(game)
    # OPTIMIZE Joe At some point benchmark this potential hot spot search. We may want to add game_id to character proxies if this is too slow. -JW
    # FIXME Joe, WTF! Associations why you no work!
    proxies = CharacterProxy.where(:user_profile_id => self.id)

    proxies.delete_if { |proxy| (proxy.game.id != game.id or not proxy.default_character) }
    proxies = proxies.compact
    raise RuntimeError.new("too many default characters exception") if proxies.count > 1
    proxies.first
  end

  # This method returns the first name + space + last name
  def full_name
    "#{self.first_name} #{self.last_name}"
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

  # This method collects all of this user_profile's roles
  def roles
    self.community_profiles.collect{|community_profile| community_profile.roles}.flatten(1) # OPTIMIZE Joe, see if we can push this down to squeel.
  end

  ###
  # This method checks if the user is a member of the given community.
  # [Args]
  #   * +community+ The community to check membership of.
  # [Returns] True if member of the community false otherwise.
  def is_member?(community)
    if community
     self.roles.include?(community.member_role)
    else
     false
    end
  end
  
  ###
  # This method checks if a user profile has viewed a view-loggable object or not. If no user is specified, current user's user profile will be used.
  # [Args]
  #   * +view_loggable_item+ -> The view-loggable object to check.
  # [Returns] True if the specified user is the owner of this character, otherwise false.
  def has_seen?(view_loggable_item)
    user_id = self.id
    ViewLog.where{(
      (view_loggable_id.eq view_loggable_item.id) & 
      (view_loggable_type.eq view_loggable_item.class.to_s) & 
      (user_profile_id.eq user_id)
    )}.exists?
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
      return (Array.new() << (self)).concat(self.available_character_proxies(community,game).map{|proxy| proxy.character})
    else
      return (Array.new() << (self)).concat(self.character_proxies.map{|proxy| proxy.character})
    end
  end
  
  ###
  # This method gets an array of unviewed announcements.
  # [Returns] An array of unviewed messages.
  ###
  def unread_announcements
    self.announcements.delete_if{|announcement| self.has_seen?(announcement)}
  end

  ###
  # This method gets an array of possible active profile options.
  # [Returns] An array that user profile + all of their characters.
  ###
  def address_book
    comm_profiles = self.communities.collect{|community| community.community_profiles}.flatten(1)
    comm_profiles.collect{|comm_profile| comm_profile.user_profile}.uniq.delete_if{|user_profile| user_profile == self}
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
# Callback Methods
###
  ###
  # _before_create_
  #
  # This method builds the user's inbox folder.
  ###
  def build_mailboxes
    self.folders.build(:name => "Inbox")
    self.folders.build(:name => "Trash")
  end
end



# == Schema Information
#
# Table name: user_profiles
#
#  id                :integer         not null, primary key
#  user_id           :integer
#  first_name        :string(255)
#  last_name         :string(255)
#  avatar            :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  description       :text
#  display_name      :string(255)
#  publicly_viewable :boolean         default(TRUE)
#

