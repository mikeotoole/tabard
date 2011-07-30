class AcknowledgmentOfAnnouncement < ActiveRecord::Base
  belongs_to :announcement
  belongs_to :profile
  
  def author_name
    @profile = Profile.find_by_id(self.profile_id)
    @profile.displayname
  end
  
  def path
    self.annoncement
  end
  
  def title
    self.announcement.name
  end
  
  def body
    self.announcement.body
  end
  
  def snippet(n=30)
    self.announcement.snippet(n)
  end
  
end
