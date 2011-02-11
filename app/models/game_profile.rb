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
    self.name
  end
  
end
