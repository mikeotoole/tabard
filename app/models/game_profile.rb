class GameProfile < Profile
  has_many :characters, :dependent => :destroy
  belongs_to :game
end
