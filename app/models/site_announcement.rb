class SiteAnnouncement < ActiveRecord::Base
    has_many :UserProfiles, :through => :AcknowledgmentOfAnnouncement
end
