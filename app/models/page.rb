class Page < ActiveRecord::Base
  #attr_accessible :title, :body, :featured_page, :page_space
  
  belongs_to :page_space
  has_one :community, :through => :discussion_space
  
  scope :featured_pages, :conditions => {:featured_page => true}
  scope :alphabetical, order("title ASC")
  
  validate :limit_number_of_pages
  
  def limit_number_of_pages
    # TODO we will want to put this in a better spot...
    max_number_of_featured_pages = 5
    errors.add(:featured_page, "The maximum number of featured pages [#{max_number_of_featured_pages}] has been reached. Please unselect one to make room.") if(max_number_of_featured_pages <= Page.featured_pages.size and self.featured_page)
  end
  
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

# == Schema Information
#
# Table name: pages
#
#  id            :integer         not null, primary key
#  created_at    :datetime
#  updated_at    :datetime
#  title         :string(255)
#  body          :text
#  page_space_id :integer
#  featured_page :boolean
#

