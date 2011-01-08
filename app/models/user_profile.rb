class UserProfile < Profile
  belongs_to :user

  has_many :game_profiles
  has_many :characters, :through => :game_profiles 
  
  def all_user_characters

  end
  
  def character_id
    -1
  end
end
