class SiteAnnouncement < Announcement
    has_many :UserProfiles, :through => :AcknowledgmentOfAnnouncement
end
