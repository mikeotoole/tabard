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

  has_many :played_games
  has_many :players, through: :played_games

###
# Validators
###
  validates :name, presence: true

###
# Public Methods
###

###
# H-Store
###
  # Setup info to use Hstore. This should not be needed for Rails 4.
  serialize :info, ActiveRecord::Coders::Hstore
  # TODO: Add index for info. -MO

###
# Instance Methods
###

  def short_name
    self.name
  end

  def full_name
    self.name
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

