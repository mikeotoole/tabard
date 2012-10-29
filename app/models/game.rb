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
  attr_accessible :name

###
# Store
###
  store :info, accessors: [:servers]

###
# Associations
###
  has_many :community_games
  has_many :communities, through: :community_games

#   has_many :played_games
#   has_many :players, through: :played_games

###
# Validators
###
  validates :name, presence: true

###
# Uploaders
###
#   mount_uploader :logo, GameLogoUploader

###
# Class Methods
###
#   ###
#   # Lets the subclasses use the parents routes.
#   # [Args]
#   #   * +child+ -> The class to check if subclass.
#   # [Returns] If is subclass of Game returns Game as model name.
#   ###
#   def self.inherited(child)
#     child.instance_eval do
#       # Defines the subclasses model name as its base class Game.
#       def model_name
#         Game.model_name
#       end
#     end
#     super
#   end

###
# Instance Methods
###

  def short_name
    self.name
  end

  def full_name
    self.name
  end

  def has_factions?
    self.factions.present?
  end

  def has_servers?
    self.servers.present?
  end

  def has_server_types?
    self.server_types.present?
  end

  def has_achievements?
    self.achievements.present?
  end

  def has_store_url?
    self.store_url.present?
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

