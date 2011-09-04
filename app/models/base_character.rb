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
# Associations
###
	# The game the character belongs to.
  belongs_to :game
  #The character_proxy that associates this character to a user.
  has_one :character_proxy, :as => :character, :dependent => :destroy, :foreign_key => :character_id

###
# Validators
###
  validates_presence_of :name, :game


	#TODO is this needed?
	###
  # This method returns the id of this character's character proxy.
  # [Returns] An integer that contains the id for this character's character proxy, if possible, otherwise nil.
	###
  def character_proxy_id
    return self.character_proxy.id if self.character_proxy
    nil
  end

	#TODO is this needed?
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
  	#TODO Why does this just return ""? Each character type defines this right.
    ""
  end

	# TODO Are we getting rid of default character?
  def default
    self.character_proxy_id == self.character_proxy.game_profile.default_character_proxy_id
  end

end
