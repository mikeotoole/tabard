class GameProfile < Profile
  has_many :characters, :dependent => :destroy
  belongs_to :game
  belongs_to :user_profile
  
  validates_presence_of :game
  validates_presence_of :user_profile
  
  def game_id
    game.id
  end
  
  #TODO This needs to be the profiles main characters name
  def displayname
    self.default_character ? self.default_character.name : self.game.name.to_s + "Default Name" 
  end
  
  def default_character
    Character.find_by_id(self.default_character_id)
  end
  
  def default_character=(character)
    self.default_character_id = character.id
  end
  
end
