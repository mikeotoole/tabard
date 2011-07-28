class CommunityAnnouncement < Announcement
  has_many :user_profiles, :through => :AcknowledgmentOfAnnouncement
  has_one :community
  
  after_create :create_acknowledgments
  def create_acknowledgments
    self.community.all_users.each do |user| 
      AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => user.user_profile.profile.id, :acknowledged => false)
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