###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents an Base Character that all others are extended from.
###
class BaseCharacter < ActiveRecord::Base
  # This is an abstract_class and therefore has no table.
  self.abstract_class = true
###
# Attribute accessors
###
  ###
  # This attribute is the avatar for this SWTOR character. It maps to the AvatarUploader.
  ###
  attr_accessor :avatar

  ###
  # This attribute is the avatar cache for this SWTOR character. It is used by the AvatarUploader.
  ###
  attr_accessor :avatar_cache

  ###
  # This attribute is the avatar removal for this SWTOR character. It is used by the AvatarUploader.
  ###
  attr_accessor :remove_avatar

  ###
  # This attribute is used to set the character as the default.
  ###
  attr_accessor :default

###
# Associations
###
  # The game the character belongs to.
  belongs_to :game
  #The character_proxy that associates this character to a user.
  has_one :character_proxy, :as => :character, :dependent => :destroy, :foreign_key => :character_id

###
# Validators
###
  validates :name, :presence => true
  validates :game, :presence => true
  validates :avatar,
      :if => :avatar?,
      :file_size => {
        :maximum => 1.megabytes.to_i
      }

###
# Delegates
###
  delegate :set_as_default, :to => :character_proxy, :allow_nil => true
  delegate :user_profile, :to => :character_proxy, :allow_nil => true

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

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
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method returns the id of this character.
  # [Returns] An integer that contains the id for this character.
  ###
  def character_id
    self.id
  end

  ###
  # This method returns the display name of this character.
  # [Returns] A string that contains the display name for this character.
  ###
  def display_name
    self.name
  end

  ###
  # This method sets this as the default character.
  # [Args]
  #   * +value+ -> The boolean value to set.
  # [Returns] A string that contains the display name for this character.
  ###
  def default=(value)
    self.set_as_default if value
  end

  # If the character is the default for its game.
  def default
    self.character_proxy.default_character
  end

  ###
  # This method checks to see if the specified user is the owner of this character.
  # [Args]
  #   * +unknown_user+ -> The user to check.
  # [Returns] True if the specified user is the owner of this character, otherwise false.
  ###
  def owned_by_user?(unknown_user)
    self.user_profile.user == unknown_user
  end
end