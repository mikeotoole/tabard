###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Game. Only subclasses of this should be created.
###
class Game < ActiveRecord::Base
  # The list of vaild game subclass types.
  VALID_TYPES =  %w(Wow Swtor)

###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :type, :pretty_url

###
# Associations
###
  has_many :supported_games
  has_many :communities, :through => :supported_games

###
# Validators
###
  validates :name,  :presence => true
  validates :type,  :presence => true,
                    :inclusion => { :in => VALID_TYPES, :message => "%{value} is not currently a supported game" },
                    :uniqueness => true

###
# Public Methods
###
  # Let's us access the game from pretty_url instead of id
  def to_param
    self.pretty_url
  end

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



# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  pretty_url :string(255)
#

