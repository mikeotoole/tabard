class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true
  belongs_to :character
  belongs_to :user_profile
  has_many :comments, :as => :commentable
  
  def users_name
    user_profile.displayname
  end
  
  def characters_name
    character.name
  end
  
  def charater_posted?
    character != nil
  end
  
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
  end
  
  def check_user_create_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
  end
  
  def check_user_update_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
  end
  
  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end
  
end
