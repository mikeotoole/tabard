class BaseCharacter < ActiveRecord::Base
  self.abstract_class = true  
  
  belongs_to :game
  
  belongs_to :discussion
   
  validates_presence_of :name, :game
     
  #after_create :create_discussion
   
  def character_proxy_id
    character_proxy.id
  end 
   
  def character_id
    self.id
  end
 
  def create_discussion
    return if self.discussion
    user_profile = self.character_proxy.game_profile.user_profile if self.character_proxy and self.character_proxy.game_profile 
    self.discussion = Discussion.create(:discussion_space => game.character_discussion_space,
                                        :name => self.name,
                                        :body => "Character Discussion",
                                        :character_proxy => self.character_proxy,
                                        :user_profile => user_profile)   
    self.save
  end
  
  def default
    game_profile = CharacterProxy.character_game_profile(self)
    (game_profile.default_character == self) if game_profile
  end
 
  # Lets the subclasses use the parents routes. 
  # def self.inherited(child)
  #   child.instance_eval do
  #     def model_name
  #       BaseCharacter.model_name
  #     end
  #   end
  #   super
  # end
 
  # def self.factory(class_name, params = nil)
  #   class_name << "Character"
  #   if defined? class_name.constantize
  #     class_name.constantize.new(params)
  #   else
  #     Character.new(params)
  #   end
  # end
 
end
