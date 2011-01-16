class Discussion < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :character
  belongs_to :discussion_space
  has_many :comments, :as => :commentable
  
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(discussion_space)
  end
  
  def check_user_create_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_create(discussion_space)
  end
  
  def check_user_update_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_update(discussion_space)
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete(discussion_space)
  end
end
