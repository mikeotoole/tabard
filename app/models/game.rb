###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Game. Only subclasses of this should be created.
###
class Game < ActiveRecord::Base
###
# Constants
###
  VALID_GAMES = [['World of Warcraft', 'Wow'], ['Star Wars: The Old Republic', 'Swtor'], ['Minecraft', 'Minecraft'], ['Custom Game', 'CustomGame']]

###
# Attribute accessible
###
  attr_accessible :name, :aliases

###
# Associations
###
  has_many :community_games
  has_many :communities, through: :community_games

  has_many :played_games
  has_many :players, through: :played_games, class_name: "UserProfile", source: "user_profile"

###
# Validators
###
  validates :name, presence: true,
                   uniqueness: {case_sensitive: false}

###
# Public Methods
###

###
# Class Methods
###
  # Search game name and aliases for given term.
  def self.search(search)
    game_name = "%#{search}%"
    Game.where{(name =~ game_name) | (aliases =~ game_name)}
  end

  # Get an array of supported game name/type hashes
  def self.supported_list
    games = []
    VALID_GAMES.each do |game|
      next if game[1] == 'CustomGame'
      games << {name: game[0], type: game[1]}
    end
    return games
  end

  # Quick check to see if the game is supported officially or not
  def is_supported
    self.type != 'CustomGame'
  end

###
# H-Store
###
  # Setup info to use Hstore. This should not be needed for Rails 4.
  serialize :info, ActiveRecord::Coders::Hstore
end

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#  info       :hstore
#  aliases    :string(255)
#

