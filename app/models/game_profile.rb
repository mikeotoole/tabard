class GameProfile < Profile
  has_many :character_proxies, :dependent => :destroy
  belongs_to :game
  belongs_to :user_profile
  
  validates_presence_of :game
  validates_presence_of :user_profile
  
  def game_id
    game.id
  end
  
  def characters
    #self.character_proxies.collect!{|proxy| proxy.character}
    
    characters = Array.new()
    for proxy in self.character_proxies
        characters << proxy.character
    end
    characters
  end
  
  def displayname
    self.default_character ? self.default_character.name : self.game.name.to_s + "Default Name" 
  end
  
  def default_character
    cp = CharacterProxy.find_by_id(self.default_character_proxy_id)
    cp ? cp.character : nil
  end
  
  def default_character=(character)
    self.default_character_proxy_id = character.character_proxy_id
  end
  
end
