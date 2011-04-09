class BaseCharacter < ActiveRecord::Base
  self.abstract_class = true  
  
  belongs_to :game 
  belongs_to :discussion
  has_one :character_proxy, :as => :character, :dependent => :destroy, :foreign_key => :character_id
   
  validates_presence_of :name, :game
   
  def character_proxy_id
    character_proxy.id
  end 
   
  def character_id
    self.id
  end
  
  def default
    self.character_proxy_id == self.character_proxy.game_profile.default_character_proxy_id
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
 
  def check_user_show_permissions(user)
    return true
  end
  
  def check_user_create_permissions(user)
    return true
  end
  
  def check_user_update_permissions(user)
    self.character_proxy.game_profile.user_profile.id == user.user_profile.id or user.can_update("Character")
  end
  
  def check_user_delete_permissions(user)
    self.character_proxy.game_profile.user_profile.id == user.user_profile.id or user.can_delete("Character")
  end
end
