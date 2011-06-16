class DiscussionSpace < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :game
  has_many :discussions
  
  validate :only_one_announcement_space, :only_one_registration_application_space, :has_a_user_profile,
           :only_one_user_profile_space
  
  scope :user_generated, where(:system => false)
  scope :system_generated, where(:system => true)
  
  def game_name
    self.game.name if self.game
  end
  
  def only_one_announcement_space
    errors.add(:id, "There can be only one!  ...announcement space.") if (DiscussionSpace.site_announcement_space.exists? and self.announcement_space and self.game_id = nil)
  end
  
  def self.site_announcement_space
    DiscussionSpace.where(:announcement_space => true, :game_id => nil)
  end
  
  def self.registration_application_space
    if DiscussionSpace.where(:registration_application_space => true).exists?
      return DiscussionSpace.where(:registration_application_space => true).first
    else
      return DiscussionSpace.create(:name => "Registration Applications", :system => true, :registration_application_space => true)
    end 
  end
  
  def only_one_registration_application_space
    errors.add(:id, "There can be only one!  ...registration applicaiton space.") if (DiscussionSpace.where(:registration_application_space => true).exists? and self.registration_application_space)
  end
  
  def has_a_user_profile
    errors.add(:id, "Internal rails error, no user found to create a discussion space.") if (!user_profile and !system)
  end
  
  def only_one_user_profile_space
    errors.add(:id, "There can be only one!  ...user profile space.") if (DiscussionSpace.where(:user_profile_space => true).exists? and self.user_profile_space)
  end
  
  def self.user_profile_space
    if DiscussionSpace.where(:user_profile_space => true).exists?
      return DiscussionSpace.where(:user_profile_space => true).first
    else
      return DiscussionSpace.create(:name => "User Profiles ", :system => true, :user_profile_space => true)
    end 
  end
  
  def user_profile_name
    user_profile.displayname if user_profile
  end
  
  def list_in_navigation
    !self.personal_space
  end
  
  def check_user_show_permissions(user)
    return true if user_profile_space and user
    return true if self.game and self.game.character_discussion_space_id = self.id and user
    return true if user and user.user_profile == self.user_profile
    return self.announcement_space if self.announcement_space and user
    user.can_show("DiscussionSpace") if user 
  end
  
  def check_user_create_permissions(user)
    return true if user and user.user_profile == self.user_profile
    user.can_create("DiscussionSpace")
  end
  
  def check_user_update_permissions(user)
    return true if user and user.user_profile == self.user_profile
    user.can_update("DiscussionSpace") and not self.system
  end
  
  def check_user_delete_permissions(user)
    return true if user and user.user_profile == self.user_profile
    user.can_delete("DiscussionSpace") and not self.system
  end
end
