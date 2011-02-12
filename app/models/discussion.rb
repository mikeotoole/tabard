class Discussion < ActiveRecord::Base
  belongs_to :user_profile
  belongs_to :character
  belongs_to :discussion_space
  has_many :comments, :as => :commentable
  
  def users_name
    user_profile.displayname if user_profile
  end
  
  def characters_name
    character.name
  end
  
  def charater_posted?
    character != nil
  end
  
  def number_of_comments
   temp_total_num_comments = comments.size
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end 
   temp_total_num_comments
  end
  
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(DiscussionSpace.find(self.discussion_space.id)) or user.can_show("Discussion")
  end
  
  def check_user_create_permissions(user)
    user.can_create(DiscussionSpace.find(self.discussion_space.id)) or user.can_create("Discussion")
  end
  
  def check_user_update_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_update(DiscussionSpace.find(self.discussion_space.id)) or user.can_update("Discussion")
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    #Hack
    user.can_delete(DiscussionSpace.find(self.discussion_space.id)) or user.can_delete("Discussion")
  end
end
