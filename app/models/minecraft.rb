###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source

# This class represents the Star Wars the Old Republic game.
###
class Minecraft < Game
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
# Associations
###
  #has_many :minecraft_characters, :dependent => :destroy

###
# Validators
###
  validates :server_type,  :presence => true,
                    :inclusion => { :in => VALID_SERVER_TYPES, :message => "%{value} is not a valid server type." }

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

###
# Instance Methods
###
  # Calls class method by same name.
  def all_server_types
    self.class.all_server_types
  end

  # Returns the full name of this game including game type faction and server.
  def full_name
    "Minecraft (#{self.server_type})"
  end

  # Returns just basic game name
  def short_name
    "Minecraft"
  end
end

# == Schema Information
#
# Table name: minecrafts
#
#  id          :integer         not null, primary key
#  server_type :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

