class Comment < ActiveRecord::Base
  attr_accessor :form_target
  attr_accessor :comment_target
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :character_proxy
  belongs_to :user_profile
  has_many :comments, :as => :commentable
  
  before_create :use_default_character
  
  def use_default_character
    return if self.character_proxy or not(self.user_profile)
    if(self.original_comment_item.respond_to?('game'))
      self.user_profile.game_profiles.each do |game_profile|
        if(game_profile.game.id == original_comment_item.game.id)
          self.character_proxy_id = game_profile.default_character_proxy_id
        end
      end
    end
  end
  
  def users_name
    user_profile.displayname
  end
  
  def characters_name
    character_proxy.character.name
  end
  
  def character
    character_proxy.character if character_proxy
  end
  
  def charater_posted?
    character_proxy != nil
  end
  
  def number_of_comments
   temp_total_num_comments = comments.size
   comments.each do |comment|
     temp_total_num_comments += comment.number_of_comments
   end 
   temp_total_num_comments
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
  
  def replys_locked?
    self.has_been_locked or !self.original_comment_item.comments_enabled? or (self.original_comment_item.respond_to?('has_been_locked') and self.original_comment_item.has_been_locked)
  end
  def check_user_show_permissions(user)
    if user.user_profile == self.user_profile
      return true
    end
  end
  
  def check_user_create_permissions(user)
    if self.commentable.respond_to?('has_been_locked') and self.commentable.has_been_locked
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_show(original_comment_item) or user.can_create("Comment")
  end
  
  def check_user_update_permissions(user)
  	if self.has_been_locked or self.replys_locked?
  		return false
  	end
    if user.user_profile == self.user_profile
      return true
    end
    false
  end
  
  def check_user_delete_permissions(user)
    if self.has_been_locked or self.replys_locked? or self.has_been_deleted
      return false
    end
    if user.user_profile == self.user_profile
      return true
    end
    user.can_delete(original_comment_item) or user.can_delete("Comment")
  end
  
  def can_user_lock(user)
    user.can_special_permissions("Comment","lock")
  end
  
  # The commentable_type always needs to be of the base class type and not the subclass type.
  def commentable_type=(sType)
    super(sType.to_s.classify.constantize.base_class.to_s)
  end
  
end
