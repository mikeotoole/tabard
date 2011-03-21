class WowCharacter < BaseCharacter
  belongs_to :wow, :foreign_key => :game_id
  
  validates_presence_of :wow
  
  def game
    self.wow
  end
  
  def description
    "WoW Character"
  end  
  
end
