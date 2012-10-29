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
  VALID_GAMES = [['World of Warcraft', 'Wow'], ['Star Wars: The Old Republic', 'Swtor'], ['Minecraft', 'Minecraft']]

###
# Associations
###
  has_many :supported_games
  has_many :communities, through: :supported_games

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
    Wow.all + Swtor.all + Minecraft.all
  end

  ###
  # Gets a game for a given type, faction, server
  # [Args]
  #   * +type+ -> The game type
  #   * +faction+ -> The faction for game
  #   * +server_name+ -> The server for game
  # [Returns] If a game is found the game is returned. If no game is found but type is a valid game type a stubbed out game instance is returned. Otherwise nil is returned.
  ###
  def self.get_game(type, faction=nil, server_name=nil, server_type=nil)
    if type == "Wow" or type == "Swtor"
      game_class = type.constantize
      game = game_class.game_for_faction_server(faction, server_name)
      return game if game
      return game_class.new(faction: faction, server_name: server_name) if game_class and game_class.superclass.name == "Game"
    elsif type == "Minecraft"
      game = Minecraft.find(:first, conditions: {server_type: server_type})
      return game if game
      return Minecraft.new(server_type: server_type)
    end
    return nil
  end
end

# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  info       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string(255)
#

