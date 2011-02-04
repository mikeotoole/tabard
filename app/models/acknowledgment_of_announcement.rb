class AcknowledgmentOfAnnouncement < ActiveRecord::Base
  belongs_to :Announcement
  belongs_to :Profile
    
  def id
    self.announcement_id
  end
  
  def author_name
    @profile = Profile.find_by_id(self.profile_id)
    @profile.displayname
  end
  
  def title
    @announcement = Announcement.find_by_id(self.announcement_id)
    @announcement.name
  end
  
  def body
    @announcement = Announcement.find_by_id(self.announcement_id)
    @announcement.body
  end
  
  def snippet(n=30)
    @announcement = Announcement.find_by_id(self.announcement_id)
    @announcement.body.split(' ')[0,n].inject{|sum,word| sum + ' ' + word}
  end
  
end
