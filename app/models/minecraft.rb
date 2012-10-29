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
#   attr_accessible :server_type
  attr_accessible :server_types

###
# Validators
###
#   validates :server_type,  presence: true,
#                     inclusion: { in: VALID_SERVER_TYPES, message: "%{value} is not a valid server type." },
#                     uniqueness: {case_sensitive: false, message: "A game with this server type exists."}

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
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

