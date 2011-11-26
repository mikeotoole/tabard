###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source

# This class represents the Star Wars the Old Republic game.
###
class Swtor < Game
###
# Constants
###
  VALID_FACTIONS =  %w(Republic Sith)
  VALID_SERVER_TYPES =  %w(PvP PvE)

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :faction, :server_name, :server_type
  
###
# Associations
###
  has_many :characters, :dependent => :destroy
  
###
# Validators
###
  validates :faction,  :presence => true,
                    :inclusion => { :in => VALID_FACTIONS, :message => "%{value} is not a valid faction." } 
  validates :server_type,  :presence => true,
                    :inclusion => { :in => VALID_SERVER_TYPES, :message => "%{value} is not a valid server type." }
  validates :server_name, :presence => true, 
                    :uniqueness => {:case_sensitive => false, :scope => [:faction, :server_type], :message => "A game with this faction, server name, server type exists."}                  
                    
###
# Public Methods
###

  def self.all_servers
    Swtor.all.collect{|w| w.server_name}.uniq # TODO Joe, Is there a more efficient way to do this? -MO
  end
  
  def all_servers
    self.class.all_servers
  end
  
  def self.all_factions
    VALID_FACTIONS
  end
  
  def all_factions
    self.class.all_factions
  end

  def name
    "Star Wars: The Old Republic - #{self.faction} - #{self.server_name}"
  end  
end


# == Schema Information
#
# Table name: swtors
#
#  id          :integer         not null, primary key
#  faction     :string(255)
#  server_name :string(255)
#  server_type :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

