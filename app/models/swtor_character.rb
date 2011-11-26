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
  VALID_REPUBLIC_CLASSES = %w(Jedi\ Knight Jedi\ Consular Smuggler Trooper)
  VALID_SITH_CLASSES = %w(Sith\ Warrior Sith\ Inquisitor Bounty\ Hunter Imperial\ Agent)
  
  VALID_ADVANCED_CLASSES = %w(Guardian Sentinel Vanguard Commando Sage Shadow Gunslinger Scoundrel Juggernaut Marauder Powertech Mercenary Assassin Sorcerer Operative Sniper)
  
  VALID_JEDI_KNIGHT_ADVANCED_CLASSES = %w(Guardian Sentinel)
  VALID_TROOPER_ADVANCED_CLASSES = %w(Vanguard Commando)
  VALID_JEDI_CONSULAR_ADVANCED_CLASSES = %w(Sage Shadow)
  VALID_SMUGGLER_ADVANCED_CLASSES = %w(Gunslinger Scoundrel)
  
  VALID_SITH_WARRIOR_ADVANCED_CLASSES = %w(Juggernaut Marauder)
  VALID_BOUNTY_HUNTER_ADVANCED_CLASSES = %w(Powertech Mercenary)
  VALID_SITH_INQUISITOR_ADVANCED_CLASSES = %w(Assassin Sorcerer)
  VALID_IMPERIAL_AGENT_ADVANCED_CLASSES = %w(Operative Sniper)
  
  VALID_SPECIES = %w(Chiss Cyborg Human Miraluka Mirialan Rattataki Sith\ Pureblood Twi'lek Zabrak)
  
  VALID_JEDI_KNIGHT_SPECIES = %w(Human Miraluka Mirialan Twi'lek Zabrak)
  VALID_TROOPER_SPECIES = %w(Cyborg Human Mirialan Zabrak)
  VALID_JEDI_CONSULAR_SPECIES = %w(Human Miraluka Mirialan Twi'lek Zabrak)
  VALID_SMUGGLER_SPECIES = %w(Cyborg Human Mirialan Twi'lek Zabrak)
  
  VALID_SITH_WARRIOR_SPECIES = %w(Cyborg Human Sith\ Pureblood Zabrak)
  VALID_BOUNTY_HUNTER_SPECIESS = %w(Chiss Cyborg Human Rattataki Zabrak)
  VALID_SITH_INQUISITOR_SPECIESS = %w(Human Rattataki Sith\ Pureblood Twi'lek Zabrak)
  VALID_IMPERIAL_AGENT_SPECIES = %w(Chiss Cyborg Human Rattataki Zabrak)

###
# Attribute accessible
###
  attr_accessible :name, :swtor_id, :swtor, :about, :char_class, :advanced_class, :species, :level

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
    if not SwtorCharacter.classes(swtor_character.faction).include?(swtor_character.char_class)
      swtor_character.errors.add(:class, "is not valid for given faction")
    end  
  end
  validate do |swtor_character|
    if not swtor_character.advanced_class.blank? and not SwtorCharacter.advanced_classes(swtor_character.char_class).include?(swtor_character.advanced_class)
      swtor_character.errors.add(:advanced_class, "is not valid for given class")
    end   
  end
  validates :species,  :presence => true
  validate do |swtor_character|
    if not SwtorCharacter.species(swtor_character.char_class).include?(swtor_character.species)
      swtor_character.errors.add(:species, "is not valid for given class")
    end  
  end

###
# Public Methods
###

  def self.all_classes
    return VALID_REPUBLIC_CLASSES + VALID_SITH_CLASSES
  end
  
  def self.all_advanced_classes
    return VALID_ADVANCED_CLASSES
  end
  
  def self.all_species
    return VALID_SPECIES
  end

  def self.classes(faction)
    case faction
      when "Republic"
        return VALID_REPUBLIC_CLASSES
      when "Sith"
        return VALID_SITH_CLASSES
      else
        return []
     end       
  end

  def self.advanced_classes(char_class)
    case char_class
      when "Jedi Knight"
        return VALID_JEDI_KNIGHT_ADVANCED_CLASSES
      when "Trooper"
        return VALID_TROOPER_ADVANCED_CLASSES
      when "Jedi Consular"
        return VALID_JEDI_CONSULAR_ADVANCED_CLASSES
      when "Smuggler"
        return VALID_SMUGGLER_ADVANCED_CLASSES
      when "Sith Warrior"
        return VALID_SITH_WARRIOR_ADVANCED_CLASSES
      when "Bounty Hunter"
        return VALID_BOUNTY_HUNTER_ADVANCED_CLASSES
      when "Sith Inquisitor"
        return VALID_SITH_INQUISITOR_ADVANCED_CLASSES  
      when "Imperial Agent"
        return VALID_IMPERIAL_AGENT_ADVANCED_CLASSES
      else
        return []
    end
  end

  def self.species(char_class)
    case char_class
      when "Jedi Knight"
        return VALID_JEDI_KNIGHT_SPECIES
      when "Trooper"
        return VALID_TROOPER_SPECIES
      when "Jedi Consular"
        return VALID_JEDI_CONSULAR_SPECIES
      when "Smuggler"
        return VALID_SMUGGLER_SPECIES
      when "Sith Warrior"
        return VALID_SITH_WARRIOR_SPECIES
      when "Bounty Hunter"
        return VALID_BOUNTY_HUNTER_SPECIES
      when "Sith Inquisitor"
        return VALID_SITH_INQUISITOR_SPECIES  
      when "Imperial Agent"
        return VALID_IMPERIAL_AGENT_SPECIES
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

