###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Star Wars the Old Republic character.
###
class SwtorCharacter < BaseCharacter
###
# Constants
###
  VALID_REPUBLIC_CLASSES = %w(Jedi\ Knight Trooper Jedi\ Consular Smuggler)
  VALID_SITH_CLASSES = %w(Sith\ Warrior Bounty\ Hunter Sith\ Inquisitor Imperial\ Agent)
  
  VALID_RACES = %w(Chiss Cyborg Human Miraluka Mirialan Rattataki Sith\ Pureblood Twi'lek Zabrak)
  
  VALID_JEDI_KNIGHT_RACES = %w(Human Miraluka Mirialan Twi'lek Zabrak)
  VALID_TROOPER_RACES = %w(Cyborg Human Mirialan Zabrak)
  VALID_JEDI_CONSULAR_RACES = %w(Human Miraluka Mirialan Twi'lek Zabrak)
  VALID_SMUGGLER_RACES = %w(Cyborg Human Mirialan Twi'lek Zabrak)
  
  VALID_SITH_WARRIOR_RACES = %w(Cyborg Human Sith\ Pureblood Zabrak)
  VALID_BOUNTY_HUNTER_RACES = %w(Chiss Cyborg Human Rattataki Zabrak)
  VALID_SITH_INQUISITOR_RACES = %w(Human Rattataki Sith\ Pureblood Twi'lek Zabrak)
  VALID_IMPERIAL_AGENT_RACES = %w(Chiss Cyborg Human Rattataki Zabrak)

###
# Attribute accessors
###
  attr_accessor :faction, :server

###
# Attribute accessible
###
  attr_accessible :name, :swtor_id, :swtor, :about, :char_class, :race, :level

###
# Associations
###
  belongs_to :swtor

###
# Delegates
###
  delegate :faction, :to => :swtor, :allow_nil => true
  delegate :server_name, :to => :swtor, :allow_nil => true

###
# Validators
###
  validate do |swtor_character|
    swtor_character.errors.add(:game, "not found with this faction server combination") if swtor_character.swtor_id.blank?
  end
  validates :char_class,  :presence => true
  validate do |swtor_character|
    if not SwtorCharacter.classes_for_faction(swtor_character.faction).include?(swtor_character.char_class)
      swtor_character.errors.add(:class, "is not valid for given faction")
    end  
  end
  validates :race,  :presence => true
  validate do |swtor_character|
    if not SwtorCharacter.races_for_class(swtor_character.char_class).include?(swtor_character.race)
      swtor_character.errors.add(:race, "is not valid for given class")
    end  
  end

###
# Public Methods
###

  def self.all_classes
    return VALID_REPUBLIC_CLASSES + VALID_SITH_CLASSES
  end
  
  def self.all_races
    return VALID_RACES
  end

  def self.classes_for_faction(faction)
    case faction
      when "Republic"
        return VALID_REPUBLIC_CLASSES
      when "Sith"
        return VALID_SITH_CLASSES
      else
        return []
     end       
  end

  def self.races_for_class(char_class)
    case char_class
      when "Jedi Knight"
        return VALID_JEDI_KNIGHT_RACES
      when "Trooper"
        return VALID_TROOPER_RACES
      when "Jedi Consular"
        return VALID_JEDI_CONSULAR_RACES
      when "Smuggler"
        return VALID_SMUGGLER_RACES
      when "Sith Warrior"
        return VALID_SITH_WARRIOR_RACES
      when "Bounty Hunter"
        return VALID_BOUNTY_HUNTER_RACES
      when "Sith Inquisitor"
        return VALID_SITH_INQUISITOR_RACES  
      when "Imperial Agent"
        return VALID_IMPERIAL_AGENT_RACES
      else
        return []
    end
  end

###
# Instance Methods
###
  ###
  # This method gets the game for the character.
  # [Returns] The SWTOR game.
  ###
  def game
    self.swtor
  end

  ###
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "SWTOR Character"
  end
end



# == Schema Information
#
# Table name: swtor_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  swtor_id   :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  char_class :string(255)
#  race       :string(255)
#  level      :string(255)
#  about      :string(255)
#

