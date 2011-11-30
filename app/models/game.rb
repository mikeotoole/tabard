###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Game. Only subclasses of this should be created.
###
class Game < ActiveRecord::Base
  # This is an abstract_class and therefore has no table.
  self.abstract_class = true

###
# Constants
###
  VALID_GAMES = [['World of Warcraft', 'Wow'], ['Star Wars: The Old Republic', 'Swtor']]

###
# Associations
###
  has_many :supported_games
  has_many :communities, :through => :supported_games

###
# Class Methods
###
  ###
  # Lets the subclasses use the parents routes.
  # [Args]
  #   * +child+ -> The class to check if subclass.
  # [Returns] If is subclass of Game returns Game as model name.
  ###
  def self.inherited(child)
    child.instance_eval do
      # Defines the subclasses model name as its base class Game.
      def model_name
        Game.model_name
      end
    end
    super
  end

  # Gets all games
  def self.all_games
    Wow.all + Swtor.all
  end

  ###
  # Gets a game for a given type, faction, server
  # [Args]
  #   * +type+ -> The game type
  #   * +faction+ -> The faction for game
  #   * +server_name+ -> The server for game
  # [Returns] If a game is found the game is returned. If no game is found but type is a valid game type a stubbed out game instance is returned. Otherwise nil is returned.
  ###
  def self.get_game(type, faction, server_name)
    game_class = type.constantize if type
    game = game_class.game_for_faction_server(faction, server_name) if game_class and game_class.superclass.name == "Game"
    if game
      return game
    elsif game_class and game_class.superclass.name == "Game"
      return game_class.new(:faction => faction, :server_name => server_name)
    else
      return nil
    end
  end
end
