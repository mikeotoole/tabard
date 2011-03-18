class SwtorCharacter < BaseCharacter
  belongs_to :swtor, :foreign_key => :game_id
  has_one :character_proxy, :dependent => :destroy, :foreign_key => :character_id
  
  validates_presence_of :swtor
  
  def game
    self.swtor
  end
end
