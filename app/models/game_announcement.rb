class GameAnnouncement < Announcement
  belongs_to :game
  belongs_to :discussion_space
  has_many :GameProfiles, :through => :AcknowledgmentOfAnnouncement
  
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
