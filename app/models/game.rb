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
# H-Store
###
  # Setup info to use Hstore. This should not be needed for Rails 4.
  serialize :info, ActiveRecord::Coders::Hstore

  # Dynamicly add setter, getter, attr_accessible and scope for stored keys.
  %w[servers achievements].each do |key|
    attr_accessible key
    scope "has_#{key}", lambda { |value| where("info @> (? => ?)", key, value) }

    define_method(key) do
      info && info[key]
    end

    define_method("#{key}=") do |value|
      self.info = (info || {}).merge(key => value)
    end
  end

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

  def factions
    nil
  end

  def server_names
    nil
  end

  def server_types
    nil
  end
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
#

