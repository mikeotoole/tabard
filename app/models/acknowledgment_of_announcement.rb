class AcknowledgmentOfAnnouncement < ActiveRecord::Base
  belongs_to :Announcement
  belongs_to :Profile
end
