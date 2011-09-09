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
  # The character_proxy that associates this user profile to characters of various types.
  has_many :character_proxies, :dependent => :destroy, :autosave => true

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
  # This will create a new character proxy for the character and
  # add it to the user profile.
  # [Args]
  #   * +character+ -> The character to add.
  #   * +is_default+ -> If the character is the default for its game.
  ###
  def build_character(character, is_default = false)
    if not is_default and self.character_proxies_for_a_game(character.game).empty?
      is_default = true
    end
    self.character_proxies.create(:character => character, :default_character => is_default)
  end

  ###
  # This will set the character as the default for its game.
  # The previous default charcter will be unset.
  # [Args]
  #   * +character+ -> The character to set as default.
  ###
  def set_as_default_character(character)
    correct_target_proxy = self.character_proxies.find_by_character_id_and_character_type(character.id,character.class.to_s)
  end

  ###
  # This method will return all of the character proxies for this user profile who's character matches the specified game.
  # [Args]
  #   * +game+ -> The game to scope the proxies by.
  # [Returns] An array that contains all of this user profiles character proxies who's character matches the specified game.
  ###
  def character_proxies_for_a_game(game)
    # OPTIMIZE Joe At some point benchmark this potential hot spot search. We may want to add game_id to character proxies if this is too slow. -JW
    self.character_proxies.delete_if { |proxy| (proxy.game != self.game) }
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

