class Page < ActiveRecord::Base
  belongs_to :page_space
  
  def check_user_show_permissions(user)
    return true
  end
  
  def check_user_create_permissions(user)
    user.can_create(self.page_space) or user.can_create("Page")
  end
  
  def check_user_update_permissions(user)
    user.can_update(self.page_space) or user.can_update("Page")
  end
  
  def check_user_delete_permissions(user)
    user.can_delete(self.page_space) or user.can_delete("Page")
  end
end
