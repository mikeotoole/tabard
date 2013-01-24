###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Star Wars the Old Republic character.
###
class SwtorCharacter < Character
  #validates_lengths_from_database except: [:name, :avatar]

###
# Constants
###
  # All valid genders
  VALID_GENDERS = %w(Male Female)

  # all valid republic classes
  VALID_REPUBLIC_CLASSES = %w(Jedi\ Knight Jedi\ Consular Smuggler Trooper)
  # all valid empire classes
  VALID_EMPIRE_CLASSES = %w(Sith\ Warrior Sith\ Inquisitor Bounty\ Hunter Imperial\ Agent)

  # all valid advanced classes
  VALID_ADVANCED_CLASSES = %w(Assassin Commando Guardian Gunslinger Juggernaut Marauder Mercenary Operative Powertech Sage Scoundrel Sentinel Shadow Sniper Sorcerer Vanguard)

  # all valid republic advanced classes
  VALID_REPUBLIC_ADVANCED_CLASSES = %w(Guardian Sentinel Vanguard Commando Sage Shadow Gunslinger Scoundrel)
  # all valid empire advanced classes
  VALID_EMPIRE_ADVANCED_CLASSES = %w(Juggernaut Marauder Powertech Mercenary Assassin Sorcerer Operative Sniper)

  # all valid jedi knight advanced classes
  VALID_JEDI_KNIGHT_ADVANCED_CLASSES = %w(Guardian Sentinel)
  # all valid trooper advanced classes
  VALID_TROOPER_ADVANCED_CLASSES = %w(Vanguard Commando)
  # all valid jedi consular advanced classes
  VALID_JEDI_CONSULAR_ADVANCED_CLASSES = %w(Sage Shadow)
  # all valid smuggler advanced classes
  VALID_SMUGGLER_ADVANCED_CLASSES = %w(Gunslinger Scoundrel)

  # all valid sith warrior advanced classes
  VALID_SITH_WARRIOR_ADVANCED_CLASSES = %w(Juggernaut Marauder)
  # all valid bounty hunter advanced classes
  VALID_BOUNTY_HUNTER_ADVANCED_CLASSES = %w(Powertech Mercenary)
  # all valid sith inquisitor advanced classes
  VALID_SITH_INQUISITOR_ADVANCED_CLASSES = %w(Assassin Sorcerer)
  # all valid imperial agent advanced classes
  VALID_IMPERIAL_AGENT_ADVANCED_CLASSES = %w(Operative Sniper)

  # all valid species
  VALID_SPECIES = %w(Chiss Cyborg Human Miraluka Mirialan Rattataki Sith\ Pureblood Twi'lek Zabrak)

  # all valid jedi knight species
  VALID_JEDI_KNIGHT_SPECIES = %w(Human Miraluka Mirialan Twi'lek Zabrak)
  # all valid trooper species
  VALID_TROOPER_SPECIES = %w(Cyborg Human Mirialan Zabrak)
  # all valid jedi consular species
  VALID_JEDI_CONSULAR_SPECIES = %w(Human Miraluka Mirialan Twi'lek Zabrak)
  # all valid smuggler species
  VALID_SMUGGLER_SPECIES = %w(Cyborg Human Mirialan Twi'lek Zabrak)

  # all valid sith warrior species
  VALID_SITH_WARRIOR_SPECIES = %w(Cyborg Human Sith\ Pureblood Zabrak)
  # all valid bounty hunter species
  VALID_BOUNTY_HUNTER_SPECIES = %w(Chiss Cyborg Human Rattataki Zabrak)
  # all valid sith inquisitor species
  VALID_SITH_INQUISITOR_SPECIES = %w(Human Rattataki Sith\ Pureblood Twi'lek Zabrak)
  # all valid imperial agent species
  VALID_IMPERIAL_AGENT_SPECIES = %w(Chiss Cyborg Human Rattataki Zabrak)

###
# Attribute accessible
###
  attr_accessible :name, :advanced_class, :species, :level, :gender, :server_name

###
# H-Store
###
  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :advanced_class, :species, :level, :gender, :server_name

###
# Validators
###
  validates :advanced_class, presence: true,
                             inclusion: { in: VALID_ADVANCED_CLASSES, message: "%{value} is not a valid advanced class." }
  validates :species, presence: true
  validate :species_and_class_is_valid_for_advanced_class
  validates :gender, presence: true,
                     inclusion: {in: VALID_GENDERS}
  validates :level, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 50}

###
# Public Methods
###

###
# Class Methods
###
  # Gets all valid classes.
  def self.all_classes
    return VALID_REPUBLIC_CLASSES + VALID_EMPIRE_CLASSES
  end

  # Gets all valid advanced classes.
  def self.all_advanced_classes
    return VALID_ADVANCED_CLASSES
  end

  # Gets all valid species.
  def self.all_species
    return VALID_SPECIES
  end

  # Gets all valid classes for a given faction. Used to validate the class.
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

  # This is used by the controller to find the class for a given advanced class.
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

  # This is used by the controller to find the faction for a given advanced class.
  def self.faction(advanced_class)
    if VALID_REPUBLIC_ADVANCED_CLASSES.include?(advanced_class)
      return "Republic"
    elsif VALID_EMPIRE_ADVANCED_CLASSES.include?(advanced_class)
      return "Empire"
    else
      return nil
    end
  end

  # Used by the view and validator to get valid species for a given advanced class.
  def self.species_class_collection
    [
      ["Guardian", VALID_JEDI_KNIGHT_SPECIES],
      ["Sentinel", VALID_JEDI_KNIGHT_SPECIES],
      ["Vanguard", VALID_TROOPER_SPECIES],
      ["Commando", VALID_TROOPER_SPECIES],
      ["Sage", VALID_JEDI_CONSULAR_SPECIES],
      ["Shadow", VALID_JEDI_CONSULAR_SPECIES],
      ["Gunslinger", VALID_SMUGGLER_SPECIES],
      ["Scoundrel", VALID_SMUGGLER_SPECIES],
      ["Juggernaut", VALID_SITH_WARRIOR_SPECIES],
      ["Marauder", VALID_SITH_WARRIOR_SPECIES],
      ["Powertech", VALID_BOUNTY_HUNTER_SPECIES],
      ["Mercenary", VALID_BOUNTY_HUNTER_SPECIES],
      ["Assassin", VALID_SITH_INQUISITOR_SPECIES],
      ["Sorcerer", VALID_SITH_INQUISITOR_SPECIES],
      ["Operative", VALID_IMPERIAL_AGENT_SPECIES],
      ["Sniper", VALID_IMPERIAL_AGENT_SPECIES]
    ]
  end

###
# Validator Methods
###
  ###
  # _validator_
  #
  # Checks species is valid for the given advanced_class
  ###
  def species_and_class_is_valid_for_advanced_class
    species_array = SwtorCharacter.species_class_collection.select{|item| item[0] == self.advanced_class }
    vaild_species = species_array[0][1] if species_array and species_array[0]

    if not vaild_species or not vaild_species.include?(self.species)
      self.errors.add(:species, "is not valid for given class")
    end
  end
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

