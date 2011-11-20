###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents the World of Warcraft game.
###
class Wow < Game
###
# Constants
###
  VALID_FACTIONS =  %w(Alliance Horde)
  VALID_SERVER_TYPES =  %w(PvP PvE)
  
###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :faction, :server_name, :server_type

###
# Associations
###
  has_many :wow_characters, :dependent => :destroy

###
# Validators
###
  validates :faction,  :presence => true,
                    :inclusion => { :in => VALID_FACTIONS, :message => "%{value} is not a valid faction." } 
  validates :server_name, :presence => true
  validates :server_type,  :presence => true,
                    :inclusion => { :in => VALID_SERVER_TYPES, :message => "%{value} is not a valid server type." }

###
# Public Methods
###

  def name
    "World of Warcraft - #{self.faction} - #{self.server_name}"
  end
end


# == Schema Information
#
# Table name: wows
#
#  id          :integer         not null, primary key
#  faction     :string(255)
#  server_name :string(255)
#  server_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

