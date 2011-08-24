require 'test_helper'

class AcknowledgmentOfAnnouncementTest < ActiveSupport::TestCase
  fixtures :profiles, :announcements
  
  test "AcknowledgmentOfAnnouncement must have an announcement and profile" do
    a_o_a = AcknowledgmentOfAnnouncement.new
    assert a_o_a.invalid?, "acknowledgment of announcement should be invalid"
    assert a_o_a.errors[:announcement_id].any?, "announcement should not be blank"
    assert a_o_a.errors[:profile_id].any?, "profile should not be blank"
  end
  
  test "AcknowledgmentOfAnnouncement must be unaknowledged by default" do
    a_o_a = AcknowledgmentOfAnnouncement.new
    assert !a_o_a.acknowledged, "acknowledged should be false"
  end
  
  test "author_name must be working properly" do
    flunk("Not implemented")
  end
  
  test "profile_name must be working properly" do
    flunk("Not implemented")
  end
  
  test "path must be working properly" do
    flunk("Not implemented")
  end
  
  test "title must be working properly" do
    flunk("Not implemented")
  end
  
  test "body must be working properly" do
    flunk("Not implemented")
  end
end
