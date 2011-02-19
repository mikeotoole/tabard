class DiscussionSpace < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :game
  has_many :discussions
  
  validate :only_one_announcement_space, :only_one_registration_application_space, :has_a_user_profile,
           :only_one_user_profile_space
  
  def only_one_announcement_space
    errors.add(:id, "There can be only one!  ...announcement space.") if (DiscussionSpace.where(:announcement_space => true).exists? and self.announcement_space)
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
  
  def check_user_show_permissions(user)
    if user_profile_space
      return true
    end
    if self.game and self.game.character_discussion_space_id = self.id
      return true
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show("DiscussionSpace") or self.announcement_space
  end
  
  def check_user_create_permissions(user)
    user.can_create("DiscussionSpace")
  end
  
  def check_user_update_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_update("DiscussionSpace") and not self.system
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete("DiscussionSpace") and not self.system
  end
end
