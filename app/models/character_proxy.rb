class CharacterProxy < ActiveRecord::Base
  belongs_to :game_profile
  belongs_to :character, :polymorphic => true
  
  def self.all_characters
    CharacterProxy.all.collect!{|proxy| proxy.character}
  end
  
  def active_profile_id
    self.game_profile.id
  end
  
end
