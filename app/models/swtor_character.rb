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
  VALID_EMPIRE_CLASSES = %w(Sith\ Warrior Sith\ Inquisitor Bounty\ Hunter Imperial\ Agent)
  
  VALID_ADVANCED_CLASSES = %w(Guardian Sentinel Vanguard Commando Sage Shadow Gunslinger Scoundrel Juggernaut Marauder Powertech Mercenary Assassin Sorcerer Operative Sniper)
  
  VALID_REPUBLIC_ADVANCED_CLASSES = %w(Guardian Sentinel Vanguard Commando Sage Shadow Gunslinger Scoundrel)
  VALID_EMPIRE_ADVANCED_CLASSES = %w(Juggernaut Marauder Powertech Mercenary Assassin Sorcerer Operative Sniper)
  
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
  VALID_BOUNTY_HUNTER_SPECIES = %w(Chiss Cyborg Human Rattataki Zabrak)
  VALID_SITH_INQUISITOR_SPECIES = %w(Human Rattataki Sith\ Pureblood Twi'lek Zabrak)
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
    return VALID_REPUBLIC_CLASSES + VALID_EMPIRE_CLASSES
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
      when "Empire"
        return VALID_EMPIRE_CLASSES
      else
        return []
     end       
  end
  
  def self.classes_hash
    { "Republic" => VALID_REPUBLIC_CLASSES,
      "Empire" =>  VALID_EMPIRE_CLASSES }      
  end

  def self.char_class(advanced_class)
    if VALID_JEDI_KNIGHT_ADVANCED_CLASSES.include?(advanced_class)
      return "Jedi Knight"  
    elsif VALID_TROOPER_ADVANCED_CLASSES.include?(advanced_class)
      return "Trooper"
    elsif VALID_JEDI_CONSULAR_ADVANCED_CLASSES.include?(advanced_class)
      return "Jedi Consular"
    elsif VALID_SMUGGLER_ADVANCED_CLASSES.include?(advanced_class)
      return "Smuggler"
    elsif VALID_SITH_WARRIOR_ADVANCED_CLASSES.include?(advanced_class)
      return "Sith Warrior"
    elsif VALID_BOUNTY_HUNTER_ADVANCED_CLASSES.include?(advanced_class)
      return "Bounty Hunter"
    elsif VALID_SITH_INQUISITOR_ADVANCED_CLASSES.include?(advanced_class)
      return "Sith Inquisitor"  
    elsif VALID_IMPERIAL_AGENT_ADVANCED_CLASSES.include?(advanced_class)
      return "Imperial Agent"
    else
      return nil
    end
  end
  
  def self.faction(advanced_class)
    if VALID_REPUBLIC_ADVANCED_CLASSES.include?(swtor_character.advanced_class)
      return "Republic"
    elsif VALID_EMPIRE_ADVANCED_CLASSES.include?(swtor_character.advanced_class)
      return "Empire"
    else
      return nil
    end
  end
  
  def self.char_class(advanced_class)
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
  
  def self.advanced_classes_hash
    { "Jedi Knight" => VALID_JEDI_KNIGHT_ADVANCED_CLASSES,
      "Trooper" => VALID_TROOPER_ADVANCED_CLASSES,
      "Jedi Consular" => VALID_JEDI_CONSULAR_ADVANCED_CLASSES,
      "Smuggler" => VALID_SMUGGLER_ADVANCED_CLASSES,
      "Sith Warrior" => VALID_SITH_WARRIOR_ADVANCED_CLASSES,
      "Bounty Hunter" => VALID_BOUNTY_HUNTER_ADVANCED_CLASSES,
      "Sith Inquisitor" => VALID_SITH_INQUISITOR_ADVANCED_CLASSES,
      "Imperial Agent" => VALID_IMPERIAL_AGENT_ADVANCED_CLASSES }
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

  def self.species_hash
    { "Guardian" =>  VALID_JEDI_KNIGHT_SPECIES,
      "Sentinel" =>  VALID_JEDI_KNIGHT_SPECIES,
      "Vanguard" => VALID_TROOPER_SPECIES,
      "Commando" => VALID_TROOPER_SPECIES,
      "Sage" => VALID_JEDI_CONSULAR_SPECIES,
      "Shadow" => VALID_JEDI_CONSULAR_SPECIES,
      "Gunslinger" => VALID_SMUGGLER_SPECIES,
      "Scoundrel" => VALID_SMUGGLER_SPECIES,
      "Juggernaut" => VALID_SITH_WARRIOR_SPECIES,
      "Marauder" => VALID_SITH_WARRIOR_SPECIES,
      "Powertech" => VALID_BOUNTY_HUNTER_SPECIES,
      "Mercenary" => VALID_BOUNTY_HUNTER_SPECIES,
      "Assassin" => VALID_SITH_INQUISITOR_SPECIES,
      "Sorcerer" => VALID_SITH_INQUISITOR_SPECIES,
      "Operative" => VALID_IMPERIAL_AGENT_SPECIES,
      "Sniper" => VALID_IMPERIAL_AGENT_SPECIES }    
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
  # This method gets the game name for the character.
  # [Returns] The name of SWTOR
  ###
  def game_name
    "Star Wars: The Old Republic"
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
#  id             :integer         not null, primary key
#  name           :string(255)
#  swtor_id       :integer
#  avatar         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  char_class     :string(255)
#  advanced_class :string(255)
#  species        :string(255)
#  level          :string(255)
#  about          :string(255)
#

