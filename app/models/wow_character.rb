###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a World of Warcraft character.
###
class WowCharacter < Character
  #validates_lengths_from_database except: [:name, :avatar]


###
# Constants
###
  # Used by validator to limit the length of name.
  MAX_NAME_LENGTH = 12

  # All valid genders
  VALID_GENDERS = %w(Male Female)

  # All valid races
  VALID_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen Blood\ Elf Goblin Orc Pandaren Tauren Troll Undead)

  # All valid classes
  VALID_CLASSES = %w(Death\ Knight Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)

###
# All valid races by faction
###
  #Valid races
  VALID_ALLIANCE_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Pandaren Worgen)
  #Valid races
  VALID_HORDE_RACES = %w(Blood\ Elf Goblin Orc Pandaren Tauren Troll Undead)

###
# All valid alliance classes by race
###
  #Valid Draenei
  VALID_ALLIANCE_DRAENEI_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Shaman Warrior)
  #Valid Dwarf
  VALID_ALLIANCE_DWARF_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Shaman Warlock Warrior)
  #Valid Gnome
  VALID_ALLIANCE_GNOME_CLASSES = %w(Death\ Night Mage Monk Priest Rogue Warlock Warrior)
  #Valid Human
  VALID_ALLIANCE_HUMAN_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Warlock Warrior)
  #Valid Night Elf
  VALID_ALLIANCE_NIGHT_ELF_CLASSES = %w(Death\ Night Druid Hunter Mage Monk Priest Rogue Warrior)
  #Valid Worgen
  VALID_ALLIANCE_WORGEN_CLASSES = %w(Death\ Night Druid Hunter Mage Priest Rogue Warlock Warrior)
  #Valid Pandaren
  VALID_ALLIANCE_PANDAREN_CLASSES = %w(Death\ Night Hunter Mage Monk Priest Rogue Shaman Warrior)

###
# All valid horde classes by race
###
  #Valid Blood Elf
  VALID_HORDE_BLOOD_ELF_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Warlock Warrior)
  #Valid Goblin
  VALID_HORDE_GOBLIN_CLASSES = %w(Death\ Night Hunter Mage Priest Rogue Shaman Warlock Warrior)
  #Valid Orc
  VALID_HORDE_ORC_CLASSES = %w(Death\ Night Hunter Mage Monk Rogue Shaman Warlock Warrior)
  #Valid Tauren
  VALID_HORDE_TAUREN_CLASSES = %w(Death\ Night Druid Hunter Monk Paladin Priest Shaman Warrior)
  #Valid Troll
  VALID_HORDE_TROLL_CLASSES = %w(Death\ Night Druid Hunter Mage Monk Priest Rogue Shaman Warlock Warrior)
  #Valid Pandaren
  VALID_HORDE_PANDAREN_CLASSES = %w(Hunter Mage Monk Priest Rogue Shaman Warrior)
  #Valid Undead
  VALID_HORDE_UNDEAD_CLASSES = %w(Death\ Night Hunter Mage Monk Priest Rogue Warlock Warrior)

###
# Attribute accessible
###
  attr_accessible :name, :race, :level, :char_class, :gender, :faction, :server_name

###
# H-Store
###
  # Dynamicly add setter, getter, and scopes for keys (See lib/hstore_accessor.rb).
  hstore_accessor :info, :race, :level, :char_class, :gender, :faction, :server_name

###
# Validators
###
  validates :name, presence: true,
                   length: { maximum: MAX_NAME_LENGTH }

###
# Public Methods
###

###
# Class Methods
###

  # Gets all valid classes.
  def self.all_classes
    VALID_CLASSES
  end

  # Gets all valid races.
  def self.all_races
    VALID_RACES
  end

  # Used by the view to get valid races for a given faction.
  def self.faction_race_collection
    [
      ["Alliance", VALID_ALLIANCE_RACES],
      ["Horde", VALID_HORDE_RACES]
    ]
  end

  # Used by the view and validator to get valid classes for a given faction and race.
  def self.faction_race_class_collection
    [
      ["Alliance_Draenei", VALID_ALLIANCE_DRAENEI_CLASSES],
      ["Alliance_Dwarf", VALID_ALLIANCE_DWARF_CLASSES],
      ["Alliance_Gnome", VALID_ALLIANCE_GNOME_CLASSES],
      ["Alliance_Human", VALID_ALLIANCE_HUMAN_CLASSES],
      ["Alliance_Night_Elf", VALID_ALLIANCE_NIGHT_ELF_CLASSES],
      ["Alliance_Worgen", VALID_ALLIANCE_WORGEN_CLASSES],
      ["Alliance_Pandaren", VALID_ALLIANCE_PANDAREN_CLASSES],
      ["Horde_Blood_Elf", VALID_HORDE_BLOOD_ELF_CLASSES],
      ["Horde_Goblin", VALID_HORDE_GOBLIN_CLASSES],
      ["Horde_Orc", VALID_HORDE_ORC_CLASSES],
      ["Horde_Pandaren", VALID_HORDE_PANDAREN_CLASSES],
      ["Horde_Tauren", VALID_HORDE_TAUREN_CLASSES],
      ["Horde_Troll", VALID_HORDE_TROLL_CLASSES],
      ["Horde_Undead", VALID_HORDE_UNDEAD_CLASSES]
    ]
  end

###
# Instance Methods
###
  ###
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "WoW Character"
  end

  ###
  # This method returns a search scoped or simply scoped search helper
  # [Args]
  #   * +search+ -> The string search for.
  # [Returns] An array of characters
  ###
  def self.search(search)
    scoped # TODO Fix this
  end

###
# Validator Methods
###

  ###
  # _validator_
  #
  # Checks class is valid for race and faction.
  ###
  def class_is_valid_for_race
   if self.faction and self.race
     class_array = WowCharacter.faction_race_class_collection.select{|item| item[0] == "#{self.faction}_#{self.race.gsub(/\s/,'_')}" }
   end
   valid_classes = class_array[0][1] if class_array and class_array[0]

   if not valid_classes or not valid_classes.include?(self.char_class)
     self.errors.add(:char_class, "is not valid for given race")
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

