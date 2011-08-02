require 'test_helper'

class CommunityTest < ActiveSupport::TestCase
  
  test "Add a New Community" do
    community = Community.new
    community.name = "Test Community"
    community.slogan = "We are a Test Community"
    community.label = "Guild"
    community.accepting = true
    community.email_notice_on_applicant = false
    
    assert community.save
  end
  
  test "Add a New Community - Fail On Missing Name" do
    community = Community.new
    community.slogan = "We are a Test Community"
    community.label = "NotInclusionGuild"
    community.accepting = true
    community.email_notice_on_applicant = false
    
    assert !community.save
  end
  
  test "Add a New Community - Fail On Missing Slogan" do
    community = Community.new
    community.name = "Test Community"
    community.label = "NotInclusionGuild"
    community.accepting = true
    community.email_notice_on_applicant = false
    
    assert !community.save
  end
    
  test "Add a New Community - Fail On Missing Label" do
    community = Community.new
    community.name = "Test Community"
    community.slogan = "We are a Test Community"
    community.accepting = true
    community.email_notice_on_applicant = false
    
    assert !community.save
  end
  
  test "Add a New Community - Fail On Not Included Label" do
    community = Community.new
    community.name = "Test Community"
    community.slogan = "We are a Test Community"
    community.label = "NotInclusionGuild"
    community.accepting = true
    community.email_notice_on_applicant = false
    
    assert !community.save
  end
  
end

