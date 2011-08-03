class Message < ActiveRecord::Base
  attr_accessor  :to # array of people to send to
  #attr_accessible :subject, :body, :to, :author
  
  belongs_to :author, :class_name => "UserProfile"
  has_many :message_copies
  has_many :recipients, :through => :message_copies
  
  before_create :prepare_copies
  
  validates_presence_of :subject
  validates_presence_of :body
  validates_presence_of :to
  
  def prepare_copies
    return if to.blank?
    
    to.each do |recipient|
      userProfile = UserProfile.find(recipient)
      message_copies.build(:recipient_id => userProfile.id, :folder_id => userProfile.inbox.id)
    end
  end
  
  def check_user_show_permissions(user)
    self.author == user
  end
  
  def check_user_create_permissions(user)
    true
  end
  
  def check_user_update_permissions(user)
    false
  end
  
  def check_user_delete_permissions(user)
    self.recipients.each do |recipient|
      return true if recipient == user
    end
    false
  end
end

# == Schema Information
#
# Table name: messages
#
#  id         :integer         not null, primary key
#  author_id  :integer
#  subject    :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

