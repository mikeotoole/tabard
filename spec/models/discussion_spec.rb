# == Schema Information
#
# Table name: discussions
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  comments_enabled    :boolean         default(TRUE)
#  has_been_locked     :boolean         default(FALSE)
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe Discussion do
  let(:comment) { create(:comment) }
  let(:discussion) { create(:discussion) }
  let(:wow_discussion) { create(:discussion_by_wow_character) }

  it "should create a new instance given valid attributes" do
    discussion.should be_valid
  end

  it "should require name" do
    build(:discussion, :name => nil).should_not be_valid
  end

  it "should require body" do
    build(:discussion, :body => nil).should_not be_valid
  end

  it "should require user profile" do
    discussion.should be_valid
    discussion.user_profile = nil
    discussion.save.should be_false
  end
  
  it "should require discussion space" do
    discussion.should be_valid
    discussion.discussion_space = nil
    discussion.save.should be_false
  end
  
  it "should respond to community" do
    discussion.should respond_to(:community)
  end
  
  it "poster should return the user profile when there is no character proxy" do
    discussion.poster.should eq(DefaultObjects.user_profile)
  end 
  
  it "poster should return the character when there is a character proxy" do
    wow_discussion.poster.should be_a_kind_of(WowCharacter)
  end
  
  it "charater_posted? should return false when there is no character proxy" do
    discussion.charater_posted?.should be_false
  end 
  
  it "charater_posted? should return true when there is a character proxy" do
    wow_discussion.charater_posted?.should be_true
  end 
  
  it "number_of_comments should return 0 if the discussion has no comments" do
    discussion.comments.should be_empty
    discussion.number_of_comments.should eq(0)
  end
  
  it "number_of_comments should return the total number of comments attached" do
    comment.number_of_comments.should eq(1)
    leafComment = create(:comment)
    nodeComment = create(:comment)
    nodeComment.comments << leafComment
    comment.comments << nodeComment
    comment.number_of_comments.should eq(3)
    discussion.comments << comment
    discussion.number_of_comments.should eq(3)
  end

end
