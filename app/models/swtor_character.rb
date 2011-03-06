class SwtorCharacter < BaseCharacter
  
  def game
    Game.find_by_type("Swtor")
  end

end
