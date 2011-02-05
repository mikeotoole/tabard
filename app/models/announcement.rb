class Announcement < Discussion
  has_many :AcknowledgmentOfAnnouncements, :dependent => :destroy
  
  before_create :assign_to_discussion_space
  
  def assign_to_discussion_space
    if DiscussionSpace.where(:announcement_space => true).exists?
      self.discussion_space = DiscussionSpace.where(:announcement_space => true).limit(1)
    else
      self.discussion_space = DiscussionSpace.create(:name => "Site Announcements", :system => true, :announcement_space => true)
    end 
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
