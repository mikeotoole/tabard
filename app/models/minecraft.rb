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
# Public Methods
###

###
# Class Methods
###
  # Gets an array of all faction names.
  def self.server_types
    VALID_SERVER_TYPES
  end

  def self.game_name
    @minecraft_game_name ||= Minecraft.all.first.name
    return @minecraft_game_name
  end

  # Gets all minecraft characters
  def self.minecraft_characters
    MinecraftCharacters.all
  end

###
# Instance Methods
###
  # Calls class method by same name.
  def server_types
    self.class.server_types
  end

  # gets all minecraft characters
  def minecraft_characters
    self.class.minecraft_characters
  end
end

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#  info       :hstore
#  aliases    :string(255)
#

