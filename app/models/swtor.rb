###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source

# This class represents the Star Wars the Old Republic game.
###
class Swtor < Game
  validates_lengths_from_database
###
# Constants
###
  # All valid factions
  VALID_FACTIONS =  %w(Republic Empire)
  # All valid server types
  VALID_SERVER_TYPES =  %w(PvP PvE RP-PvP RP-PvE)

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model.
#   attr_accessible :faction, :server_name, :server_type
  attr_accessible :servers

###
# Associations
###
  has_many :swtor_characters, dependent: :destroy

###
# Validators
###
#   validates :faction,  presence: true,
#                     inclusion: { in: VALID_FACTIONS, message: "%{value} is not a valid faction." }
#   validates :server_type,  presence: true,
#                     inclusion: { in: VALID_SERVER_TYPES, message: "%{value} is not a valid server type." }
#   validates :server_name, presence: true,
#                     uniqueness: {case_sensitive: false, scope: [:faction, :server_type], message: "A game with this faction, server name, server type exists."}

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
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#

