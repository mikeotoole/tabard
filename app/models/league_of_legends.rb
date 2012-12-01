###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents the World of Warcraft game.
###
class LeagueOfLegends < Game
  validates_lengths_from_database
###
# Constants
###
  # all valid regions
  VALID_REGIONS =  %w(North\ America EU\ West EU\ Nordic\ &\ East Brazil Turkey)

###
# Associations
###
  has_many :league_of_legends_characters, dependent: :destroy


###
# Attribute accessible
###
  attr_accessible :champions

###
# H-Store
###
  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :champions

###
# Public Methods
###

###
# Class Methods
###
  # Gets an array of all faction names.
  def self.regions
    VALID_REGIONS
  end

  def self.champion_names
    LeagueOfLegends.all.first.try(:champion_names)
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
  # example champion_array.first[:name]
  # example champion_array.first[:url]
  # example champion_array.first[:avatar]
  ###
  def champion_array
    array = []
    if self.champions.present?
      self.champions.split(",").each do |server|
        a_server = server.split("|")
        array << {name: a_server[0].strip}
      end
    end
    array
  end

  def champion_names
    self.champion_array.map{|ca| ca[:name]}
  end

  # Calls class method by same name.
  def regions
    self.class.regions
  end

  def new_character(params)
    LeagueOfLegendsCharacter.new(params)
  end

  def set_specific_community_game_attributes
    return false
  end

  def update_community_game_attributes(community_game)
    # Not Needed
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

