class PageSpace < ActiveRecord::Base
  has_many :pages, :dependent => :destroy
  has_many :games
  
  def check_user_show_permissions(user)
    return true
  end
  def check_user_create_permissions(user)
    user.can_create("PageSpace")
  end
  
  def check_user_update_permissions(user)
    user.can_update("PageSpace")
  end
  
  def check_user_delete_permissions(user)
    user.can_delete("PageSpace")
  end
end
