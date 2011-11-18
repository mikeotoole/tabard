###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Star Wars the Old Republic character.
###
class SwtorCharacter < BaseCharacter
###
# Attribute accessible
###
  #attr_accessible :name, :server, :game

###
# Associations
###
  belongs_to :swtor, :foreign_key => :game_id

###
# Validators
###
  validates :swtor, :presence => true

###
# Public Methods
###

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
#  server     :string(255)
#  game_id    :integer
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

