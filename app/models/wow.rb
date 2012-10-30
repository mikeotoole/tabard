###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents the World of Warcraft game.
###
class Wow < Game
  validates_lengths_from_database
###
# Constants
###
  # all valid factions
  VALID_FACTIONS =  %w(Alliance Horde)
  # all valid server types
  VALID_SERVER_TYPES =  %w(PvP PvE RP\ PvP RP)

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :servers

###
# Associations
###
  has_many :wow_characters, dependent: :destroy

###
# Public Methods
###

###
# Class Methods
###
  # Gets an array of all faction names.
  def self.factions
    VALID_FACTIONS
  end

###
# Instance Methods
###

  # Calls class method by same name.
  def server_names
    self.servers.map{|s| s[0]}
  end

  # Calls class method by same name.
  def factions
    self.class.factions
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
#

