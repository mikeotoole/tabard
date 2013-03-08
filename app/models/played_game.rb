###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a PlayedGame. That is a game that a user said they play.
###
class PlayedGame < ActiveRecord::Base
###
# Attribute accessible
###
  attr_accessible :game_id, :user_profile_id, :game_name

###
# Associations
###
  belongs_to :game
  belongs_to :user_profile
  has_many :characters, dependent: :destroy, order: 'LOWER(name)', conditions: {is_removed: nil}

###
# Delegates
###
  delegate :type, to: :game, prefix: true, allow_nil: true

###
# Validators
###
  validates :game, presence: true
  validates :game_id, uniqueness: {scope: :user_profile_id}

###
# Public Methods
###
  # This returns the game name for this character.
  def game_name
    game.try(:name)
  end

  ###
  # This will set the charcters game using the games name.
  # If a game does not exist with that name an new game is created.
  # [Args]
  #   * +name+ -> A string containing the name of the game to set for this character.
  ###
  def game_name=(name)
    if name.present?
      some_game = Game.where(name: name).first
      some_game = CustomGame.where(name: name).first_or_create if some_game.blank?
      self.game = some_game
    end
  end

  ###
  # This will build a new character associated to this played game.
  # [Args]
  #   * +params+ -> A hash of attributes to use when creating the character.
  # [Returns] The newly created character. This is not saved yet.
  ###
  def new_character(params)
    character = self.game.new_character(params)
    character.played_game = self
    return character
  end
end

# == Schema Information
#
# Table name: played_games
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  user_profile_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

