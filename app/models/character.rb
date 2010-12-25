class Character < ActiveRecord::Base
 belongs_to :game
 
 validates_presence_of :name
 
  # Lets the subclasses use the parents routes. 
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Character.model_name
      end
    end
    super
  end

  def type_helper
    self.type
  end
  def type_helper=(type)
    self.type = type
  end
 
 def self.factory(type, params = nil)
    params[:type] ||= 'Character'
    class_name = params[:type]
    if defined? class_name.constantize
    class_name.constantize.new(params)
    else
    Character.new(params)
    end
 end
 
end
