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
# Attribute accessible
###
  attr_accessible :avatar, :avatar_cache, :remove_avatar, :remote_avatar_url

###
# Associations
###
  #The character_proxy that associates this character to a user.
  has_one :character_proxy, :as => :character, :foreign_key => :character_id

###
# Validators
###
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }
  validates :avatar,
      :if => :avatar?,
      :file_size => {
        :maximum => 1.megabytes.to_i
      }

###
# Delegates
###
  delegate :user_profile, :to => :character_proxy, :allow_nil => true
  delegate :roster_assignments, :to => :character_proxy, :allow_nil => true
  delegate :is_removed, :to => :character_proxy, :allow_nil => true

###
# Uploaders
###
  mount_uploader :avatar, AvatarUploader

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
  # This method checks to see if the specified user is the owner of this character.
  # [Args]
  #   * +unknown_user+ -> The user to check.
  # [Returns] True if the specified user is the owner of this character, otherwise false.
  ###
  def owned_by_user?(unknown_user)
    self.user_profile.user == unknown_user
  end

  # Checks if this character should be viewable or messageable.
  def is_disabled?
    self.is_removed or self.user_profile.is_disabled?
  end

  # Overrides the destroy to only mark as deleted and removes chaacter from any rosters.
  def destroy
    self.roster_assignments.clear if self.roster_assignments
    self.character_proxy.update_attribute(:is_removed, true)
    self.remove_avatar!
  end

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
