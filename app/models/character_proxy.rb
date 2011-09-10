###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Character Proxy.
###
class CharacterProxy < ActiveRecord::Base
###
# Callbacks
###
  before_save :check_one_default_character_exists

###
# Associations
###
  belongs_to :user_profile
  belongs_to :character, :polymorphic => true, :dependent => :destroy

###
# Validators
###
  validates :user_profile, :presence => true
  validates :character, :presence => true

###
# Delegates
###
  delegate :game, :to => :character
  delegate :game_id, :to => :character

###
# Public Methods
###

###
# Class Methods
###
  ###
  # This method gets all characters, regardless of their game.
  # [Returns] An array that contains all characters.
  ###
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end

  ###
  # This method gets the user profile for a character.
  # [Args]
  # * +character+ -> The character to use in the search.
  # [Returns] A user_profile for the character argument, otherwise nil.
  ###
  def self.character_user_profile(character)
    proxy = CharacterProxy.find_by_character_id(character)
    profile = proxy.user_profile if proxy
    profile
  end

###
# Instance Methods
###
#   ###
#   # This method gets the active_profile_id for this character proxy.
#   # [Returns] The id of this character_proxy's user_profile.
#   ###
#   def active_profile_id
#     self.user_profile.id
#   end

  ###
  # Sets this character proxy as default for characters game.
  ###
  def set_as_default
    self.update_attributes(:default_character => true) unless self.default_character
  end

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # This method is an callback that checks that there is one and only one default for this characters game.
  ###
  def check_one_default_character_exists
    default_proxy = self.user_profile.default_character_proxy_for_a_game(self.character.game)
    if default_proxy == nil
      self.default_character = true
    elsif self.default_character == true
      default_proxy.update_attribute(:default_character, false)
    end
  end
end

# == Schema Information
#
# Table name: character_proxies
#
#  id                :integer         not null, primary key
#  user_profile_id   :integer
#  character_id      :integer
#  character_type    :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  default_character :boolean         default(FALSE)
#

