class Wow < Game
  has_many :wow_characters, :foreign_key => "game_id", :dependent => :destroy
  
  def self.showall
    @wows = Wow.find(:all)
  end
  
end
