###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a League Of Legends character.
###
class LeagueOfLegendsCharacter < Character
  #validates_lengths_from_database except: [:name, :avatar]

###
# Constants
###

###
# Attribute accessible
###
  attr_accessor :champions
  attr_accessible :name, :region, :champions, :level

###
# Callbacks
###
  before_save :convert_characters

###
# H-Store
###
  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :region, :level, :prefered_champions

###
# Validators
###
  validates :name, presence: true
  validates :level, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 30}

###
# Public Methods
###
  def convert_characters
    return if self.champions.blank?
    clean_champion_array = Array.new
    champions.to_s.delete("[]").split(',').each do |champion|
      scrubbed = champion.strip.delete("\"")
      clean_champion_array << scrubbed if not scrubbed.blank? and LeagueOfLegends.champion_names.include?(scrubbed)
    end
    self.prefered_champions = clean_champion_array.to_json
  end

  def prefered_champions_array
    if self.prefered_champions.blank?
      return Array.new
    else
      return JSON.parse(self.prefered_champions)
    end
  end

  def prefers_champion?(name)
    return prefered_champions_array.include?(name)
  end

###
# Class Methods
###

###
# Validator Methods
###

end

# == Schema Information
#
# Table name: characters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  avatar         :string(255)
#  about          :text
#  played_game_id :integer
#  info           :hstore
#  type           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  is_removed     :boolean
#

