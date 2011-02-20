class UserProfile < Profile
  belongs_to :user
  belongs_to :discussion

  has_many :game_profiles
  has_many :characters, :through => :game_profiles 
  
  has_many :registration_applications
  
  after_create :create_discussion
  
  # User can only have one user profile
  validates_uniqueness_of :user_id
  
  def status_string
    if is_applicant
      "Applicant"
    elsif is_active
      "Active User"
    elsif is_inactive
      "Deactivated User"
    elsif is_rejected
      "Rejected"  
    else
      "Unknown"
    end
  end
  
  def is_applicant
    if self.status == 1
      return true
    else
      return false  
    end
  end
  
  def is_active
    if self.status == 2
      return true
    else
      return false  
    end
  end
  
  def is_inactive
    if self.status == 3
      return true
    else
      return false  
    end   
  end
  
  def is_rejected
    if self.status == 4
      return true
    else
      return false  
    end   
  end
  
  def set_applicant
    self.status = 1
  end
  
  def set_active
    self.status = 2  
  end
  
  def set_inactive
    self.status = 3   
  end
  
  def set_rejected
    self.status = 4
  end
  
  def self.active_profiles
    UserProfile.find(:all, :conditions => {:status => 2})
  end
  
  def all_characters
    self.characters
  end
  
  def displayname
    self.name
  end
  
  #TODO What is this??
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
