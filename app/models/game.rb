###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class represents a Game. Only subclasses of this should be created.
###
class Game < ActiveRecord::Base
###
# Attribute accessible
###
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :is_active, :type
  
###
# Associations
###
 	has_many :supported_games
	has_many :communities, :through => :supported_games

###
# Validators
###
	validates :name, :presence => true
	
###
# Scopes
###
	scope :active, :conditions => {:is_active => true}

###
# Public Methods
###

###
# Class Methods
###	
	###
 	# Lets the subclasses use the parents routes.
 	# [Args]
 	#		* +child+ -> The class to check if subclass.
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

	###
  # Used to offer a dynamically generated list of subclass to choose from.
  # [Returns] Array of strings contaning all Game subclass names.
  ###
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end

###
# Instance Methods
###
	###
	# Get the game type (class name).
	# [Returns] String with game type (class name).
	###
  def type_helper
    self.type
  end
  
  ###
  # Sets the game type.
  # [Args]
  #		* +type+ String of game type (class name).
  ###
  def type_helper=(type)
    self.type = type
  end

end

# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  type       :string(255)
#  is_active  :boolean         default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

