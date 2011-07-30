class Announcement < ActiveRecord::Base
  has_many :acknowledgment_of_announcements, :dependent => :destroy
  
  after_create :create_acknowledgments
  
  def create_acknowledgments
    true
  end  
    
  def snippet(n=30)
    snippet = (self.body.split(' ')[0,n].inject{|sum,word| sum + ' ' + word}).to_s
    snippet.length < self.body.length ? snippet << '&hellip;' : snippet
  end
  
  def self.select_options
    descendants.map{ |c| c.to_s }.sort
  end
  
  def type_helper
    self.type
  end
  def type_helper=(type)
    self.type = type
  end
  
end
