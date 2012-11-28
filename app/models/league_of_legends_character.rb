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
  attr_accessible :name, :region, :champions

###
# H-Store
###
  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :region, :champions

###
# Validators
###
  validates :name, presence: true
  # NEED TO CHECK CHAMPIONS

###
# Public Methods
###

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

