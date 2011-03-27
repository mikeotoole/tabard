class PageSpace < ActiveRecord::Base
  has_many :pages, :dependent => :destroy
  belongs_to :game
  
  def game_name
    self.game.name if self.game
  end
  
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
