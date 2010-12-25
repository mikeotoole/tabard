class Game < ActiveRecord::Base
 has_many :characters, :dependent => :destroy
 
 validates_presence_of :name
 
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

  def type_helper
    self.type
  end
  def type_helper=(type)
    self.type = type
  end

end
