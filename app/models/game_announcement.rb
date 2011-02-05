class GameAnnouncement < Announcement
  belongs_to :game
  belongs_to :discussion_space
  has_many :GameProfiles, :through => :AcknowledgmentOfAnnouncement
  
  def create_acknowledgments
    @users = User.find(:all, :conditions => {:is_active => true})
    @game = Game.find(:first, :conditions => {:id => self.game_id})
      
    for user in @users
      @userprofile = UserProfile.find_by_id(user)
      if @userprofile != nil
        @gameprofile = @userprofile.game_profiles.find(:first, :conditions => {:game_id => @game.id})
        if @gameprofile != nil
          AcknowledgmentOfAnnouncement.create(:announcement_id => self.id, :profile_id => @gameprofile.id, :acknowledged => false)
        end
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
