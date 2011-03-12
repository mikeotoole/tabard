class Swtor < Game
   has_many :swtor_characters, :foreign_key => :game_id, :dependent => :destroy
   
  def characters
    self.swtor_characters
  end
end
