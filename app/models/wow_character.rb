###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a World of Warcraft character.
###
class WowCharacter < BaseCharacter
###
# Attribute accessible
###
  attr_accessible :name, :race, :level, :wow_id

###
# Associations
###
  belongs_to :wow

###
# Validators
###
  validates :wow, :presence => true

###
# Public Methods
###

###
# Instance Methods
###
  ###
  # This method gets the game for the character.
  # [Returns] The WOW game.
  ###
  def game
    self.wow
  end

  ###
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "WoW Character"
  end
end


# == Schema Information
#
# Table name: wow_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  race       :string(255)
#  level      :integer
#  wow_id     :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

