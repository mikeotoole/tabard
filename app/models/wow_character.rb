###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a World of Warcraft character.
###
class WowCharacter < BaseCharacter
###
# Constants
###
  # All valid classes
  VALID_CLASSES = %w(Death\ Knight Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)
  # All valid races
  VALID_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen Blood\ Elf Goblin Orc Tauren Troll Pandaren Undead)

  # All valid alliance races
  VALID_ALLIANCE_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen Pandaren)
  # All valid horde races
  VALID_HORDE_RACES = %w(Blood\ Elf Goblin Orc Tauren Troll Pandaren Undead)

  # All valid alliance draenei classes
  VALID_ALLIANCE_DRAENEI_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Shaman Warrior)
  # All valid alliance dwarf classes
  VALID_ALLIANCE_DWARF_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Shaman Warlock Warrior)
  # All valid alliance gnome classes
  VALID_ALLIANCE_GNOME_CLASSES = %w(Death\ Night Mage Monk Priest Rogue Warlock Warrior)
  # All valid alliance human classes
  VALID_ALLIANCE_HUMAN_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Warlock Warrior)
  # All valid alliance night elf classes
  VALID_ALLIANCE_NIGHT_ELF_CLASSES = %w(Death\ Night Druid Hunter Mage Monk Priest Rogue Warrior)
  # All valid alliance worgen classes
  VALID_ALLIANCE_WORGEN_CLASSES = %w(Death\ Night Druid Hunter Mage Priest Rogue Warlock Warrior)
  # All valid alliance pandaren classes
  VALID_ALLIANCE_PANDAREN_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Shaman Warrior)

  # All valid horde blood elf classes
  VALID_HORDE_BLOOD_ELF_CLASSES = %w(Death\ Night Hunter Mage Monk Paladin Priest Rogue Warlock Warrior)
  # All valid horde goblin classes
  VALID_HORDE_GOBLIN_CLASSES = %w(Death\ Night Hunter Mage Priest Rogue Shaman Warlock Warrior)
  # All valid horde orc classes
  VALID_HORDE_ORC_CLASSES = %w(Death\ Night Hunter Mage Monk Rogue Shaman Warlock Warrior)
  # All valid horde tauren classes
  VALID_HORDE_TAUREN_CLASSES = %w(Death\ Night Druid Hunter Monk Paladin Priest Shaman Warrior)
  # All valid horde troll classes
  VALID_HORDE_TROLL_CLASSES = %w(Death\ Night Druid Hunter Mage Monk Priest Rogue Shaman Warlock Warrior)
  # All valid horde pandaren classes
  VALID_HORDE_PANDAREN_CLASSES = %w(Hunter Mage Monk Priest Rogue Shaman Warrior)
  # All valid horde undead classes
  VALID_HORDE_UNDEAD_CLASSES = %w(Death\ Night Hunter Mage Monk Priest Rogue Warlock Warrior)

###
# Attribute accessible
###
  attr_accessible :name, :race, :level, :wow_id, :wow, :about, :char_class

###
# Associations
###
  belongs_to :wow

###
# Delegates
###
  delegate :faction, :to => :wow, :allow_nil => true
  delegate :server_name, :to => :wow, :allow_nil => true

###
# Validators
###
  validate do |wow_character|
    wow_character.errors.add(:game, "not found with this faction server combination") if wow_character.wow_id.blank?
  end
  validates :race,  :presence => true
  validates :char_class,  :presence => true
  validate :class_is_valid_for_race

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

  # Creates a new wow character with the given params.
  def self.create_character(params, user)
    if params[:wow_character]
      wow = Wow.game_for_faction_server(params[:wow_character][:faction], params[:wow_character][:server_name])
      params[:wow_character][:wow] = wow
      wow_character = WowCharacter.create(params[:wow_character])

      if wow_character.valid?
        profile = user.user_profile
        proxy = profile.character_proxies.build(:character => wow_character, :default_character => params[:wow_character][:default])
        wow_character.errors.add(:error, "could not add character to user profile") unless proxy.save
      else
        wow_character.errors.add(:server_name, "can't be blank") if not params[:wow_character][:server_name]
        wow_character.errors.add(:faction, "can't be blank") if not params[:wow_character][:faction]
      end
      return wow_character
    end
  end

###
# Instance Methods
###
  ###
  # This method gets the game for the character.
  # [Returns] The WOW game.
  ###
  def game
    self.wow
  end

  ###
  # This method gets the game name for the character.
  # [Returns] The name of WoW
  ###
  def game_name
    "World of Warcraft"
  end

  ###
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "WoW Character"
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
# Table name: wow_characters
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  race       :string(255)
#  level      :integer
#  wow_id     :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  char_class :string(255)
#  about      :text
#

