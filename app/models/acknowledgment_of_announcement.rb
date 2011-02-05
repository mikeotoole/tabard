class AcknowledgmentOfAnnouncement < ActiveRecord::Base
  belongs_to :Announcement
  belongs_to :Profile
  
  def author_name
    @profile = Profile.find_by_id(self.profile_id)
    @profile.displayname
  end
  
  def path
    Announcement.find_by_id(self.announcement_id)
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
    Announcement.find_by_id(self.announcement_id).snippet(n)
  end
  
end
