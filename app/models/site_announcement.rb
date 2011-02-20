class SiteAnnouncement < Announcement
  has_many :UserProfiles, :through => :AcknowledgmentOfAnnouncement
    
  def create_acknowledgments
    @userprofiles = UserProfile.active_profiles
    
    for profile in @userprofiles     
      AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => profile.id, :acknowledged => false)
    end
  end
    
  def check_user_show_permissions(user)
    true
  end
  
  def check_user_create_permissions(user)
    user.can_create("SiteAnnouncement")
  end
  
  def check_user_update_permissions(user)
    user.can_update("SiteAnnouncement")
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("SiteAnnouncement")
  end
end
