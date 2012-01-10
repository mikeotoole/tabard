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
  belongs_to :character, :polymorphic => true, :dependent => :destroy
  has_many :roster_assignments
  has_many :community_profiles, :through => :roster_assignments
  has_and_belongs_to_many :community_applications

###
# Validators
###
  validates :user_profile, :presence => true
  validates :character_id, :presence => true
  validates :character_type, :presence => true

###
# Delegates
###
  delegate :name, :to => :character
  delegate :game, :to => :character
  delegate :game_id, :to => :character
  delegate :game_name, :to => :character
  delegate :avatar_url, :to => :character, :allow_nil => true

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
    proxy = CharacterProxy.find_by_character_id(character.id)
    profile = proxy.user_profile if proxy
    profile
  end

###
# Instance Methods
###
  ###
  # Sets this character proxy as default for characters game.
  ###
  def set_as_default
    self.update_attributes(:is_default_character => true) unless self.is_default_character
  end
end




# == Schema Information
#
# Table name: character_proxies
#
#  id                   :integer         not null, primary key
#  user_profile_id      :integer
#  character_id         :integer
#  character_type       :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  is_default_character :boolean         default(FALSE)
#

