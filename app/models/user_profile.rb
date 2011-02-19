class UserProfile < Profile
  belongs_to :user
  belongs_to :discussion

  has_many :game_profiles
  has_many :characters, :through => :game_profiles 
  
  has_many :registration_applications
  
  after_create :create_discussion
  
  def all_characters
    self.characters
  end

  def displayname
    self.name
  end
  
  def character_id
    -1
  end
  
  def create_discussion
    self.discussion = Discussion.create(:discussion_space => DiscussionSpace.user_profile_space,
                                        :name => self.displayname,
                                        :body => "User Profile Discussion",
                                        :user_profile => self)
  end
  
end
