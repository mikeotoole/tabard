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
  # This method returns the id of this character's character proxy.
  # [Returns] An integer that contains the id for this character's character proxy, if possible, otherwise nil.
  ###
  def character_proxy_id
    return self.character_proxy.id if self.character_proxy
    nil
  end

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
    self.method_defined? :display_name ? self.display_name : ""
  end

  # If the character is the default for its game.
  def default
    self.character_proxy.default_character
  end
end
