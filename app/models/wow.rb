class Wow < Game
  has_many :wow_characters, :foreign_key => :game_id, :dependent => :destroy
  
  def characters
    self.wow_characters
  end
end
