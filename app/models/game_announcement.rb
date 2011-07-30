class GameAnnouncement < CommunityAnnouncement
  attr_accessible :name, :body, :user_profile, :game_profiles, :community, :game
  belongs_to :game
  has_many :game_profiles, :through => :acknowledgment_of_announcements
  belongs_to :user_profile
  
  after_create :create_acknowledgments
  
  validate :name, :presence => true
  validate :body, :presence => true
  validate :user_profile, :presence => true
  validate :community, :presence => true
  validate :game, :presence => true
  
  def create_acknowledgments
    user_profiles = Array.new
    self.community.all_users.each do |user| 
      user_profiles << user.user_profile
    end
    
    for profile in user_profiles
      game_profile = profile.game_profiles.find(:first, :conditions => {:game_id => self.game.id})
        if game_profile != nil
          AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => game_profile.id, :acknowledged => false)
        end
    end
  end
  
  def assign_to_discussion_space
    self.discussion_space = self.game.announcement_space
  end
  
  def check_user_show_permissions(user)
    user.all_game_profiles.each do |gameprofile|
      if game.id == gameprofile.game_id
        return true
      end
    end
    user.can_show("GameAnnouncement") or user.can_show("SiteAnnouncement") 
  end
  
  def check_user_create_permissions(user)
    user.can_create("GameAnnouncement") or user.can_create("SiteAnnouncement")
  end
  
  def check_user_update_permissions(user)
    user.can_update("GameAnnouncement") or user.can_update("SiteAnnouncement")
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("GameAnnouncement") or user.can_delete("SiteAnnouncement")
  end
end
