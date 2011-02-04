class UserProfile < Profile
  belongs_to :user

  has_many :game_profiles
  has_many :characters, :through => :game_profiles 
  
  has_many :registration_applications
  
  def all_characters
    self.characters
  end

  def displayname
    self.name
  end
  
  def character_id
    -1
  end
  
end
