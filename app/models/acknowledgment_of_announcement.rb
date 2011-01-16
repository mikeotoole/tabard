class AcknowledgmentOfAnnouncement < ActiveRecord::Base
  belongs_to :Announcement
  belongs_to :Profile
  
  def displayname
    @profile = Profile.find_by_id(self.profile_id)
    @profile.displayname
  end
  
  def title
    @announcement = Announcement.find_by_id(self.announcement_id)
    @announcement.name
  end
  
end
