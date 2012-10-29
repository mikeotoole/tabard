###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source

# This class represents the Star Wars the Old Republic game.
###
class Minecraft < Game
  validates_lengths_from_database
###
# Constants
###
  # All valid server types
  VALID_SERVER_TYPES =  %w(Survival PvP FreeBuild)

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model.
  attr_accessible :server_type

###
# Validators
###
  validates :server_type,  presence: true,
                    inclusion: { in: VALID_SERVER_TYPES, message: "%{value} is not a valid server type." },
                    uniqueness: {case_sensitive: false, message: "A game with this server type exists."}

###
# Public Methods
###

###
# Class Methods
###
  # Gets an array of all faction names.
  def self.all_server_types
    VALID_SERVER_TYPES
  end

  # Gets a game instance for given faction server combination
  def self.game_for_server_type(server_type)
    minecraft = Minecraft.find_by_server_type(server_type).first
    return minecraft
  end

  # Gets all minecraft characters
  def self.minecraft_characters
    MinecraftCharacters.all
  end

###
# Instance Methods
###
  # Calls class method by same name.
  def all_server_types
    self.class.all_server_types
  end

  # gets all minecraft characters
  def minecraft_characters
    self.class.minecraft_characters
  end

  # Returns the full name of this game including game type faction and server.
  def full_name
    "Minecraft (#{self.server_type})"
  end

  # Returns just basic game name
  def short_name
    "Minecraft"
  end

  # Gets the server name
  def server_name
    nil
  end

  # Gets the faction
  def faction
    nil
  end
end

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

