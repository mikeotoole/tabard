class CommunityAnnouncement < Announcement
  attr_accessible :name, :body, :user_profile, :user_profiles, :community
  
  has_many :user_profiles, :through => :acknowledgment_of_announcements
  has_one :community
  belongs_to :user_profile
  
  after_create :create_acknowledgments
  
  validate :name, :presence => true
  validate :body, :presence => true
  validate :user_profile, :presence => true
  validate :community, :presence => true
  
  def create_acknowledgments
    self.community.all_users.each do |user| 
      AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => user.user_profile.id, :acknowledged => false)
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