class GameProfile < Profile
  has_many :character_proxies, :dependent => :destroy, :after_add => :default_proxy_adder
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
    cp.character if cp
  end
  
  def default_character=(character)
    self.default_character_proxy_id = character.character_proxy_id
  end
  
  def self.users_game_profile(userprofile, game)
    @gameprofile = GameProfile.find_by_user_profile_id_and_game_id(userprofile.id, game.id) if userprofile and game
  end
  
  def default_proxy_adder(character_proxy)
    self.default_character_proxy_id = character_proxy.id unless self.default_character_proxy_id
    self.save
  end
  
end
