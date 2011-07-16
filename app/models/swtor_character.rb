class SwtorCharacter < BaseCharacter
  attr_accessible :avatar, :avatar_cache
  attr_accessible :name, :server, :game, :discussion
  
  belongs_to :swtor, :foreign_key => :game_id
  
  validates_presence_of :swtor
  
  def game
    self.swtor
  end
  
  def description
    "SWTOR Character"
  end    
  
end
