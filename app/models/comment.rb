class Comment < ActiveRecord::Base
  attr_accessor :form_target
  attr_accessor :comment_target
  
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
  
  def html_classes
    html_classes = Array.new()
    html_classes << 'locked' if has_been_locked
    html_classes << 'edited' if has_been_edited
    #html_classes << 'deleted' if has_been_deleted
    #html_classes << 'op' if is_by_op
    html_classes
  end
  
  def original_comment_item
  	(commentable.respond_to?('original_comment_item')) ? commentable.original_comment_item : commentable
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
    user.can_show(original_comment_item) or user.can_create("Comment")
  end
  
  def check_user_update_permissions(user)
  	if has_been_locked 
  		return false
  	end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(original_comment_item) or user.can_update("Comment")
  end
  
  def check_user_delete_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete(original_comment_item) or user.can_delete("Comment")
  end
  
  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end
  
end
