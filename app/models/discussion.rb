class Discussion < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :character
  belongs_to :discussion_space
  has_many :comments, :as => :commentable
  
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(self.discussion_space) or user.can_show("Discussion")
  end
  
  def check_user_create_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_create(self.discussion_space) or user.can_create("Discussion")
  end
  
  def check_user_update_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_update(self.discussion_space) or user.can_update("Discussion")
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete(self.discussion_space) or user.can_delete("Discussion")
  end
end
