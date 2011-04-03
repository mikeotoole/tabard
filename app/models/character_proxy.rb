class CharacterProxy < ActiveRecord::Base
  belongs_to :game_profile
  belongs_to :character, :polymorphic => true, :autosave => true
  
  #TODO validate game_profile
  #validates_presence_of :character 
  
  after_create :default_gp_checker
  
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end
  
  def self.character_game_profile(character)
    proxy = CharacterProxy.find_by_character_id(character)
    profile = proxy.game_profile if proxy
    profile
  end
  
  def active_profile_id
    self.game_profile.id
  end
  
  def default_gp_checker
    self.game_profile.default_proxy_adder(self)
  end
  
  # def create_character_discussion
  #   self.character.create_discussion
  # end
end
