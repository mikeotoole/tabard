class SiteAnnouncement < Announcement
  attr_accessible :name, :body, :user_profiles, :community
  
  has_many :user_profiles, :through => :acknowledgment_of_announcements
  
  after_create :create_acknowledgments
  
  validate :name, :presence => true
  validate :body, :presence => true
  
  def create_acknowledgments
    @userprofiles = UserProfile.all
    
    for profile in @userprofiles     
      AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => profile.id, :acknowledged => false)
    end
  end
    
  def check_user_show_permissions(user)
    true
  end
  
  def check_user_create_permissions(user)
    false
  end
  
  def check_user_update_permissions(user)
    false
  end
  
  def check_user_delete_permissions(user)
    false
  end
end
