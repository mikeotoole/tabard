class BaseCharacter < ActiveRecord::Base
  self.abstract_class = true  
  
  #belongs_to :game
  has_one :character_proxy, :as => :character
  
  #TODO refactor for new model
  #belongs_to :discussion
   
  validates_presence_of :name
   
  #after_create :create_discussion
  
  def game
    self.game
  end
   
  def character_proxy_id
    character_proxy.id
  end 
   
  def character_id
    self.id
  end
 
  #TODO refactor for new model
  # def create_discussion
  #   user_profile = self.game_profile.user_profile if game_profile
  #   self.discussion = Discussion.create(:discussion_space => game.character_discussion_space,
  #                                       :name => self.name,
  #                                       :body => "Character Discussion",
  #                                       :character => self,
  #                                       :user_profile => user_profile)                                 
  # end
 
  # Lets the subclasses use the parents routes. 
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Character.model_name
      end
    end
    super
  end
 
  # def self.factory(class_name, params = nil)
  #   class_name << "Character"
  #   if defined? class_name.constantize
  #     class_name.constantize.new(params)
  #   else
  #     #TODO a base character type is created here. May just make this an error.
  #     Character.new(params)
  #   end
  # end
 
end
