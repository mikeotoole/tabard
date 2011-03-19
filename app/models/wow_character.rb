class WowCharacter < BaseCharacter
  belongs_to :wow, :foreign_key => :game_id
  has_one :character_proxy, :dependent => :destroy, :foreign_key => :character_id
  
  validates_presence_of :wow
  
  def game
    self.wow
  end
end
