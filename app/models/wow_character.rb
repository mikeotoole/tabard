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
  VALID_CLASSES = %w(Death\ Knight Druid Hunter Mage Paladin Priest Rogue Shaman Warlock Warrior)
  VALID_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen Blood\ Elf Forsaken Goblin Orc Tauren Troll)
  
  VALID_ALLIANCE_DEATH_KNIGHT_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen)
  VALID_HORDE_DEATH_KNIGHT_RACES = %w(Blood\ Elf Forsaken Goblin Orc Tauren Troll)
  
  VALID_ALLIANCE_DRUID_RACES = %w(Night\ Elf Worgen)
  VALID_HORDE_DRUID_RACES = %w(Tauren Troll)
  
  VALID_ALLIANCE_HUNTER_RACES = %w(Draenei Dwarf Human Night\ Elf Worgen)
  VALID_HORDE_HUNTER_RACES = %w(Blood\ Elf Forsaken Goblin Orc Tauren Troll)
  
  VALID_ALLIANCE_MAGE_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen)
  VALID_HORDE_MAGE_RACES = %w(Blood\ Elf Forsaken Goblin Orc Troll)
  
  VALID_ALLIANCE_PALADIN_RACES = %w(Draenei Dwarf Human)
  VALID_HORDE_PALADIN_RACES = %w(Blood\ Elf Tauren)
  
  VALID_ALLIANCE_PRIEST_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen)
  VALID_HORDE_PRIEST_RACES = %w(Blood\ Elf Forsaken Goblin Tauren Troll)
  
  VALID_ALLIANCE_ROGUE_RACES = %w(Dwarf Gnome Human Night\ Elf Worgen)
  VALID_HORDE_ROGUE_RACES = %w(Blood\ Elf Forsaken Goblin Orc Troll)
  
  VALID_ALLIANCE_SHAMAN_RACES = %w(Draenei Dwarf)
  VALID_HORDE_SHAMAN_RACES = %w(Goblin Orc Tauren Troll)
  
  VALID_ALLIANCE_WARLOCK_RACES = %w(Dwarf Gnome Human Worgen)
  VALID_HORDE_WARLOCK_RACES = %w(Blood\ Elf Forsaken Goblin Orc Troll)
  
  VALID_ALLIANCE_WARRIOR_RACES = %w(Draenei Dwarf Gnome Human Night\ Elf Worgen)
  VALID_HORDE_WARRIOR_RACES = %w(Blood\ Elf Forsaken Goblin Orc Tauren Troll)

###
# Attribute accessors
###
  attr_accessor :faction, :server

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
  validates :char_class,  :presence => true,
                    :inclusion => { :in => VALID_CLASSES, :message => "%{value} is not a valid class." }
  validates :race,  :presence => true
  validate do |wow_character|
    if not WowCharacter.races_for_faction_class(wow_character.faction, wow_character.char_class).include?(wow_character.race)
      wow_character.errors.add(:race, "is not valid for given faction and class")
    end  
  end                 

###
# Public Methods
###
  
  def self.races_for_faction_class(faction, char_class)
    case faction
      when "Alliance"
        case char_class
          when "Death Knight"
            return VALID_ALLIANCE_DEATH_KNIGHT_RACES
          when "Druid"
            return VALID_ALLIANCE_DRUID_RACES
          when "Hunter"
            return VALID_ALLIANCE_HUNTER_RACES
          when "Mage"
            return VALID_ALLIANCE_MAGE_RACES
          when "Paladin"
            return VALID_ALLIANCE_PALADIN_RACES
          when "Priest"
            return VALID_ALLIANCE_PRIEST_RACES
          when "Rogue"
            return VALID_ALLIANCE_ROGUE_RACES  
          when "Shaman"
            return VALID_ALLIANCE_SHAMAN_RACES
          when "Warlock"
            return VALID_ALLIANCE_WARLOCK_RACES
          when "Warrior"
            return VALID_ALLIANCE_WARRIOR_RACES
          else
            return []
        end                   
      when "Horde"
        case char_class
          when "Death Knight"
            return VALID_HORDE_DEATH_KNIGHT_RACES
          when "Druid"
            return VALID_HORDE_DRUID_RACES
          when "Hunter"
            return VALID_HORDE_HUNTER_RACES
          when "Mage"
            return VALID_HORDE_MAGE_RACES
          when "Paladin"
            return VALID_HORDE_PALADIN_RACES
          when "Priest"
            return VALID_HORDE_PRIEST_RACES
          when "Rogue"
            return VALID_HORDE_ROGUE_RACES  
          when "Shaman"
            return VALID_HORDE_SHAMAN_RACES
          when "Warlock"
            return VALID_HORDE_WARLOCK_RACES
          when "Warrior"
            return VALID_HORDE_WARRIOR_RACES
          else
            return []
        end
      else
        return []
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
  # This method gets the description for the character.
  # [Returns] A string that contains the description of the character.
  ###
  def description
    "WoW Character"
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

