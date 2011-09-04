###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Character Proxy.
###
class CharacterProxy < ActiveRecord::Base

#TODO Can we have it automaticly create these section tags?
###
# Attribute accessible
###

###
# Associations
###
	belongs_to :user_profile
  belongs_to :character, :polymorphic => true, :autosave => true

###
# Validators
###
	validates_presence_of :user_profile, :character

###
# After Create
###
  after_create :default_gp_checker # TODO Are we getting rid of default character?

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
  # This method gets the active_profile_id for this character proxy.
  # [Returns] The id of this character_proxy's game_profile.
	###
  def active_profile_id
    self.game_profile.id	#TODO Do we need this?
  end

	###
  # _after_create_
	#
  # This method is an after_create method that adds this character proxy to the default game profile.
	###
  def default_gp_checker # TODO Are we getting rid of default character?
    self.game_profile.default_proxy_adder(self) if self.game_profile
  end
end

# == Schema Information
#
# Table name: character_proxies
#
#  id              :integer         not null, primary key
#  user_profile_id :integer
#  character_id    :integer
#  character_type  :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

