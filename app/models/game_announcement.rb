class GameAnnouncement < Announcement
  belongs_to :Game
  has_many :GameProfiles, :through => :AcknowledgmentOfAnnouncement
end
