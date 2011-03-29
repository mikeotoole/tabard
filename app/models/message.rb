class Message < ActiveRecord::Base
  belongs_to :author, :class_name => "UserProfile"
  has_many :message_copies
  has_many :recipients, :through => :message_copies
  
  before_create :prepare_copies
  
  attr_accessor  :to # array of people to send to
  attr_accessible :subject, :body, :to
  
  def prepare_copies
    return if to.blank?
    
    to.each do |recipient|
      userProfile = UserProfile.find(recipient)
      message_copies.build(:recipient_id => userProfile.id, :folder_id => userProfile.inbox.id)
    end
  end
  
end
