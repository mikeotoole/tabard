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
# Callbacks
###
  after_destroy :removed_unused_custom_games

###
# Delegates
###
  delegate :type, to: :game, prefix: true, allow_nil: true

###
# Validators
###
  validates :game_id, presence: true, uniqueness: {scope: :user_profile_id}

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
  def game_name=(some_name)
    if some_name.present?
      some_game = Game.where(name: some_name).first
      if some_game.blank?
        some_game = CustomGame.where(name: some_name).first_or_create
        unless some_game.valid?
          some_game = Game.where{name.matches some_name}.first
        end
      end
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

  def removed_unused_custom_games
    if self.game.class == CustomGame and self.game.played_games.count <= 0
      self.game.destroy
    end
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

