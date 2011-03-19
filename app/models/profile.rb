class Profile < ActiveRecord::Base
  #belongs_to :user
  
  has_many :AcknowledgmentOfAnnouncements
  has_many :Announcements, :through => :AcknowledgmentOfAnnouncement
  
  validates_presence_of :name
  
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end
  
  def type_helper
    self.type
  end
  
  def type_helper=(type)
    self.type = type
  end
  
  def owned_by?(owner) 
    return false unless owner.is_a? User 
    user == owner
  end
  
end
