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
# Associations
###
  has_many :wow_characters, dependent: :destroy


###
# Attribute accessible
###
  attr_accessible :servers

###
# H-Store
###
  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :servers

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
  ###
  # Gets a hash with all severs and server meta data.
  # example server_array.first[:name]
  # example server_array.first[:type]
  # example server_array.first[:region]
  ###
  def server_array
    array = []
    self.servers.split(",").each do |server|
      a_server = server.split("|")
      array << {name: a_server[0].strip, type: a_server[1].strip, region: a_server[2].strip}
    end
    array
  end

  def server_names
    self.server_array.map{|sa| sa[:name]}
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

