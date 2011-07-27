class SiteAnnouncement < Announcement
  has_many :UserProfiles, :through => :AcknowledgmentOfAnnouncement
  
  after_create :create_acknowledgments
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
