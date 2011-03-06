class WowCharacter < BaseCharacter
  
  def game
    Game.find_by_type("Wow")
  end
  
end
