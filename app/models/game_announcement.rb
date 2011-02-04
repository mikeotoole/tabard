class GameAnnouncement < Announcement
  belongs_to :Game
  has_many :GameProfiles, :through => :AcknowledgmentOfAnnouncement
  
  def check_user_show_permissions(user)
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
