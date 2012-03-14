###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Minecraft character.
###
class MinecraftCharacter < BaseCharacter
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
  validates :name, :presence => true, 
                   :length => { :maximum => MAX_NAME_LENGTH }

###
# Public Methods
###

###
# Class Methods
###
  # Creates a new wow character with the given params.
  def self.create_character(params, user)
    if params[:minecraft_character]
      minecraft_character = MinecraftCharacter.create(params[:minecraft_character])

      if minecraft_character.valid?
        profile = user.user_profile
        proxy = profile.character_proxies.build(:character => minecraft_character)
        minecraft_character.errors.add(:error, "could not add character to user profile") unless proxy.save
      end
      return minecraft_character
    end
  end

###
# Instance Methods
###
  ###
  # This method gets a game for the character.
  # [Returns] A Minecraft game.
  ###
  def game
    Minecraft.first
  end

  ###
  # This method gets the game name for the character.
  # [Returns] The name of Minecraft
  ###
  def game_name
    "Minecraft"
  end

  ###
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "Minecraft Character"
  end
end

# == Schema Information
#
# Table name: minecraft_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  avatar     :string(255)
#  about      :text
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

