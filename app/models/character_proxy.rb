###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Character Proxy.
###
class CharacterProxy < ActiveRecord::Base
###
# Associations
###
  belongs_to :user_profile
  belongs_to :character, :polymorphic => true, :autosave => true

###
# Validators
###
  validates :user_profile, :presence => true
  validates :character, :presence => true
  validate :default_character_exists

###
# Delegates
###
  delegate :set_as_default_character, :to => :user_profile
  delegate :game, :to => character
  delegate :game_id, :to => character
  
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
  ###
  # This method gets the active_profile_id for this character proxy.
  # [Returns] The id of this character_proxy's user_profile.
  ###
  def active_profile_id
    self.user_profile.id
  end

###
# Protected Methods
###
protected

###
# Validators
###
  ###
  # This method is an validator method that checks that there is a default for this characters game.
  ###
  def default_character_exists
    current_related_proxies = self.user_profile.character_proxies_for_a_game(self.game).delete_if { |proxy| 
        (not proxy.default_character) or  
        (proxy.id == self.id)
      }
    if (current_related_proxies.empty? and not self.default_character)
      self.errors[:default_character] << "need one default character per game"
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
#  default_character :boolean         default(TRUE)
#

