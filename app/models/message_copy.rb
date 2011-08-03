class MessageCopy < ActiveRecord::Base
  delegate   :author, :created_at, :subject, :body, :recipients, :to => :message
  belongs_to :message
  belongs_to :recipient, :class_name => "UserProfile"
  belongs_to :folder
  
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
# == Schema Information
#
# Table name: message_copies
#
#  id           :integer         not null, primary key
#  recipient_id :integer
#  message_id   :integer
#  folder_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#  deleted      :boolean
#

