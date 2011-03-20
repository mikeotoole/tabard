class SwtorCharacter < BaseCharacter
  belongs_to :swtor, :foreign_key => :game_id
  
  validates_presence_of :swtor
  
  def game
    self.swtor
  end
  
  def description
    "SWTOR Character"
  end    
  
end
