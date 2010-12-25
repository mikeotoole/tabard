class WowCharacter < Character
  belongs_to :wow, :foreign_key => "game_id"
  
  def self.showall
    @characters = Character.find(:all)
  end
  
end
