# == Schema Information
#
# Table name: comments
#
#  id                 :integer         not null, primary key
#  body               :text
#  user_profile_id    :integer
#  character_proxy_id :integer
#  community_id       :integer
#  commentable_id     :integer
#  commentable_type   :string(255)
#  has_been_deleted   :boolean         default(FALSE)
#  has_been_edited    :boolean         default(FALSE)
#  has_been_locked    :boolean         default(FALSE)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Comment do
  let(:comment) { create(:comment) }
  let(:wow_comment) { create(:comment_by_wow_character) }

  it "should create a new instance given valid attributes" do
    comment.should be_valid
  end

  it "should require body" do
    build(:comment, :body => nil).should_not be_valid
  end

  it "should require user profile" do
    comment.should be_valid
    comment.user_profile = nil
    comment.save.should be_false
  end
  
  it "should require commentable type" do
    lambda { build(:comment, :commentable_type => nil) }.should raise_error
  end
  
  it "should require commentable id" do
    build(:comment, :commentable_id => nil).should_not be_valid
  end

  it "should require community" do
    comment.should be_valid
    comment.community = nil
    comment.save.should be_false
  end
  
  it "has_been_deleted should be false by default" do
    comment.has_been_deleted.should be_false
  end 
  
  it "has_been_edited should be false by default" do
    comment.has_been_edited.should be_false
  end 
  
  it "has_been_locked should be false by default" do
    comment.has_been_locked.should be_false
  end
  
  it "should have community set to current community" do
    comment.community_id.should eq(DefaultObjects.community.id)
  end 
  
  it "poster should return the user profile when there is no character proxy" do
    comment.poster.should eq(DefaultObjects.user_profile)
  end 
  
  it "poster should return the character when there is a character proxy" do
    wow_comment.poster.should be_a_kind_of(WowCharacter)
  end
  
  it "charater_posted? should return false when there is no character proxy" do
    comment.charater_posted?.should be_false
  end 
  
  it "charater_posted? should return true when there is a character proxy" do
    wow_comment.charater_posted?.should be_true
  end 
  
  it "number_of_comments should return 1 if the comment has no replies" do
    comment.number_of_comments.should eq(1)
  end
  
  it "number_of_comments should return the total number of comments attached" do
    comment.number_of_comments.should eq(1)
    leafComment = create(:comment)
    nodeComment = create(:comment)
    nodeComment.comments << leafComment
    comment.comments << nodeComment
    comment.number_of_comments.should eq(3)
  end
  
  it "html_classes should be empty if comment is not locked or edited" do
    comment.html_classes.should be_empty
  end
  
  it "html_classes should contain 'edited' if comment is not locked and is edited" do
    comment.html_classes.should be_empty
    comment.has_been_edited = true
    comment.save.should be_true
    comment.html_classes.include?('edited').should be_true
  end
  
  it "html_classes should contain 'locked' if comment is locked and not edited" do
    comment.html_classes.should be_empty
    comment.has_been_locked = true
    comment.save.should be_true
    comment.html_classes.include?('locked').should be_true
  end
  
  it "html_classes should contain 'locked' and 'edited' if comment is locked and edited" do
    comment.html_classes.should be_empty
    comment.has_been_locked = true
    comment.has_been_edited = true
    comment.save.should be_true
    comment.html_classes.include?('locked').should be_true
    comment.html_classes.include?('edited').should be_true
  end
  
  it "original_comment_item should return 1 if the comment has no replies" do
    leafComment = create(:comment)
    nodeComment = create(:comment)
    nodeComment.comments << leafComment
    comment.comments << nodeComment
    leafComment.original_comment_item.should eq(DefaultObjects.discussion)
  end
  
  it "replys_locked? should return false when has_been_locked is false" do
    comment.replys_locked?.should be_false
  end 
  
  it "replys_locked? should return true when has_been_locked is true" do
    comment.has_been_locked = true
    comment.save
    comment.replys_locked?.should be_true
  end 
  
end
