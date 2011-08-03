class PageSpace < ActiveRecord::Base
  attr_accessible :name, :game, :community, :pages
  has_many :pages, :dependent => :destroy
  belongs_to :game
  belongs_to :community
  
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

# == Schema Information
#
# Table name: page_spaces
#
#  id           :integer         not null, primary key
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string(255)
#  game_id      :integer
#  community_id :integer
#

