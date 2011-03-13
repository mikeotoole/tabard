class CharacterProxy < ActiveRecord::Base
  belongs_to :game_profile
  belongs_to :character, :polymorphic => true
  
  validates_presence_of :game_profile, :character
  
  after_create :default_gp_checker
  
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end
  
  def active_profile_id
    self.game_profile.id
  end
  
  def default_gp_checker
    self.game_profile.default_proxy_adder(self)
  end
end