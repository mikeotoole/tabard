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
  attr_accessible :faction, :server_name, :server_type

###
# Associations
###
  has_many :wow_characters, dependent: :destroy

###
# Validators
###
  validates :faction,  presence: true,
                    inclusion: { in: VALID_FACTIONS, message: "%{value} is not a valid faction." }
  validates :server_type,  presence: true,
                    inclusion: { in: VALID_SERVER_TYPES, message: "%{value} is not a valid server type." }
  validates :server_name, presence: true,
                    uniqueness: {case_sensitive: false, scope: [:faction, :server_type], message: "A game with this faction, server name, server type exists."}

###
# Public Methods
###

###
# Class Methods
###

  # Gets an array of all server names.
  def self.all_servers
    Wow.order(:server_name).collect{|game| game.server_name}.uniq
  end

  # Gets an array of all faction names.
  def self.all_factions
    VALID_FACTIONS
  end

  # Gets a game instance for given faction server combination
  def self.game_for_faction_server(faction, server)
    wow = Wow.find(:first, conditions: {faction: faction, server_name: server})
    wow = Wow.new(faction: faction, server_name: server) unless wow
    return wow
  end

###
# Instance Methods
###

  # Calls class method by same name.
  def all_servers
    self.class.all_servers
  end

  # Calls class method by same name.
  def all_factions
    self.class.all_factions
  end

  # Returns the full name of this game including game type faction and server.
  def full_name
    "World of Warcraft (#{self.faction}) #{self.server_name}"
  end

  # Returns just basic game name
  def short_name
    "World of Warcraft"
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

