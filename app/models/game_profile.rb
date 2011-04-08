class GameProfile < Profile
  has_many :character_proxies, :dependent => :destroy, :autosave => true
  belongs_to :game
  belongs_to :user_profile
  
  belongs_to :default_character_proxy, :class_name => "CharacterProxy"
  
  validates_presence_of :game
  validates_presence_of :user_profile
  
  def game_id
    game.id
  end
  
  def characters
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
    self.default_character_proxy.character if self.default_character_proxy
  end
  
  def default_character=(character)
    self.default_character_proxy = character.character_proxy
  end
  
  def self.users_game_profile(userprofile, game)
    @gameprofile = GameProfile.find_by_user_profile_id_and_game_id(userprofile.id, game.id) if userprofile and game
  end
  
  def default_proxy_adder(character_proxy)
    unless self.default_character_proxy
      self.default_character_proxy = character_proxy
      self.save
    end
  end
  
end
