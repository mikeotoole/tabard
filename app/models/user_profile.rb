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
  # This will create a new character proxy for the character and
  # add it to the user profile.
  # [Args]
  #   * +character+ -> The character to add.
  #   * +is_default+ -> If the character is the default for its game.
  ###
  def build_character(character, is_default = false)
#     self.game_profiles.each do |game_profile|
#       if game_profile.game_id == character.game_id
#         proxy = game_profile.character_proxies.build(:character => character)
#         game_profile.default_character_proxy = proxy if is_default and proxy
#         return true
#       end
#     end
#
#     # create new game profile
#     game_profile = GameProfile.new(:game => character.game, :name => "#{self.name} #{character.game.name} Profile", :user_profile => self)
#     game_profile.character_proxies.build(:character => character)
#     self.game_profiles << game_profile
    # TODO Joe, Update this method for new design.
    true
  end

  ###
  # This will set the character as the default for its game.
  # The previous default charcter will be unset.
  # [Args]
  #   * +character+ -> The chaaracter to set as default.
  ###
  def set_as_default_character(character)
    # TODO Joe, Make this work.
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

