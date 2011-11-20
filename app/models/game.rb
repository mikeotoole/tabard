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
end
