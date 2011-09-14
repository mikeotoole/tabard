###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This class represents a user's profile.
###
class UserProfile < ActiveRecord::Base
###
# Attribute Accessors
###
  ###
  # This attribute is the avatar for this user profile. It maps to the AvatarUploader.
  ###
  attr_accessor :avatar

  ###
  # This attribute is the avatar cache for this user profile. It is used by the AvatarUploader.
  ###
  attr_accessor :avatar_cache

  ###
  # This attribute is the avatar removal for this user profile. It is used by the AvatarUploader.
  ###
  attr_accessor :remove_avatar

###
# Associations
###
  belongs_to :user, :inverse_of => :user_profile
  has_many :owned_communities, :class_name => "Community", :foreign_key => "admin_profile_id"
  has_many :community_profiles, :dependent => :destroy
  has_many :character_proxies, :dependent => :destroy
###
# Delegates
###
  delegate :email, :to => :user

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

###
# Validators
###
  validates :first_name,
      :presence => true
  validates :last_name,
      :presence => true
  validates :user,
      :presence => true
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
    "#{self.first_name} #{self.last_name}"
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
    #debugger
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
# Protected Methods
###
protected

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
end

# == Schema Information
#
# Table name: user_profiles
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  first_name :string(255)
#  last_name  :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

