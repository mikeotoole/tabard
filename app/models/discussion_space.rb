class DiscussionSpace < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :game
  has_many :discussions
  
  validate :only_one_announcement_space
  
  def only_one_announcement_space
    errors.add("There can be only one!  ...announcement space") if DiscussionSpace.where(:announcement_space => true).exists?
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
    user.can_update("DiscussionSpace")
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete("DiscussionSpace")
  end
end
