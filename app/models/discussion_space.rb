class DiscussionSpace < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :game
  has_many :discussions
  
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show("DiscussionSpace")
  end
  
  def check_user_create_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
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
