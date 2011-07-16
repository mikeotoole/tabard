class WowCharacter < BaseCharacter
  attr_accessible :avatar, :avatar_cache
  attr_accessible :name, :faction, :race, :level, :server, :game, :discussion
  
  belongs_to :wow, :foreign_key => :game_id
  
  validates_presence_of :wow
  
  def game
    self.wow
  end
  
  def description
    "WoW Character"
  end  
  
end
