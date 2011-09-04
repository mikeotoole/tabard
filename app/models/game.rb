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
	validates_presence_of :name
	
	#TODO How should this be organized?
	scope :active, :conditions => {:is_active => true}


 # Lets the subclasses use the parents routes.
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Game.model_name
      end
    end
    super
  end

  # Used to offer a dynamically generated list of subclass to choose from.
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end

	# Used to set and get the game type.
  def type_helper
    self.type
  end
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

