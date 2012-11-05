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

  def self.server_names
    Wow.all.first.try(:server_names)
  end

  def self.game_name
    @wow_game_name ||= Wow.all.first.name
    return @wow_game_name
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
    if self.servers.present?
      self.servers.split(",").each do |server|
        a_server = server.split("|")
        array << {name: a_server[0].strip, type: a_server[1].strip, region: a_server[2].strip}
      end
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

  def new_character(params)
    WowCharacter.new(params)
  end

  def set_specific_community_game_attributes
    return true
  end

  def update_community_game_attributes(community_game)
    server = nil
    server_array.each do |server_info|
      if server_info[:name] == community_game.server_name
        server = server_info
        break
      end
    end
    community_game.server_type = server[:type] unless server.blank?
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

