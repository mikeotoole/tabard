###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Minecraft character.
###
class MinecraftCharacter < Character
  #validates_lengths_from_database except: [:name, :avatar]

###
# Constants
###
  # Used by validator to limit the length of name.
  MAX_NAME_LENGTH = 16

###
# Attribute accessible
###
  attr_accessible :name, :about

###
# Validators
###
  validates :name, presence: true,
                   length: { maximum: MAX_NAME_LENGTH }

###
# Public Methods
###

###
# Class Methods
###

###
# Instance Methods
###

  ###
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "Minecraft Character"
  end

  ###
  # This method returns a search scoped or simply scoped search helper
  # [Args]
  #   * +search+ -> The string search for.
  # [Returns] An array of characters
  ###
  def self.search(search)
    scoped # TODO Fix this
  end

end

# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  avatar         :string(255)
#  about          :text
#  played_game_id :integer
#  info           :hstore
#  type           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_removed     :boolean
#

