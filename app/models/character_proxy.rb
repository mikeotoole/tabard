class CharacterProxy < ActiveRecord::Base
  belongs_to :game_profile
  belongs_to :character, :polymorphic => true, :autosave => true
  
  #TODO validate game_profile. Because of our creation design does this need to happen? If so it will need to be an after_create. -MO
  validates_presence_of :character
  
  after_create :default_gp_checker, :validate_game_profile
  
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
    self.game_profile.default_proxy_adder(self) if self.game_profile
  end
  
  def validate_game_profile
    unless self.game_profile
      logger.error "**ERROR** CharacterProxy was missing it's game profile! This very bad."
    end
  end
  
  # def create_character_discussion
  #   self.character.create_discussion
  # end
end
