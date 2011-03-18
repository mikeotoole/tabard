class CharacterProxy < ActiveRecord::Base
  belongs_to :game_profile
  belongs_to :character, :polymorphic => true
  
  validates_presence_of :game_profile, :character
  
  after_create :default_gp_checker, :create_character_discussion
  
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end
  
  def active_profile_id
    self.game_profile.id
  end
  
  def default_gp_checker
    self.game_profile.default_proxy_adder(self)
  end
  
  def create_character_discussion
    self.character.create_discussion
  end
end
