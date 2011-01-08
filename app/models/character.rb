class Character < ActiveRecord::Base
 belongs_to :game
 belongs_to :game_profile
 
 validates_presence_of :name
 
 def active_profile_id
   game_profile.id
 end
 
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
 
  def self.factory(class_name, game_id, params = nil)
    params[:game_id] ||= game_id
    class_name << "Character"
    if defined? class_name.constantize
      class_name.constantize.new(params)
    else
      Character.new(params)
    end
  end
 
end
