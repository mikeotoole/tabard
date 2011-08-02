require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  test "Add a New Announcement" do
    announcement = Announcement.new
    announcement.name = "Test Announcement"
    announcement.body = "This is a Test Announcement"
    
    assert announcement.save
  end
end
