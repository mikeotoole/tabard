class Announcement < ActiveRecord::Base
  has_many :DiscussionSpaces
  has_many :AcknowledgmentOfAnnouncements
  has_many :Profiles, :through => AcknowledgmentOfAnnouncement
end
