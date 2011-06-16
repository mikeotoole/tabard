class MessageCopy < ActiveRecord::Base
  belongs_to :message
  belongs_to :recipient, :class_name => "UserProfile"
  belongs_to :folder
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :message
  
  def check_user_show_permissions(user)
    self.recipient == user
  end
  
  def check_user_create_permissions(user)
    false
  end
  
  def check_user_update_permissions(user)
    false
  end
  
  def check_user_delete_permissions(user)
    self.recipient == user
  end
end