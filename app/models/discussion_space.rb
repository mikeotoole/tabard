class DiscussionSpace < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :game
  has_many :discussions
  
  validate :only_one_announcement_space, :only_one_registration_application_space, :has_a_user_profile
  
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
  
  def check_user_show_permissions(user)
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
