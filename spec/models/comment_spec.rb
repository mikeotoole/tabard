# == Schema Information
#
# Table name: comments
#
#  id                 :integer          not null, primary key
#  body               :text
#  user_profile_id    :integer
#  character_proxy_id :integer
#  community_id       :integer
#  commentable_id     :integer
#  commentable_type   :string(255)
#  is_removed         :boolean          default(FALSE)
#  has_been_edited    :boolean          default(FALSE)
#  is_locked          :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
  
  it "is_removed should be false by default" do
    comment.is_removed.should be_false
  end 
  
  it "has_been_edited should be false by default" do
    comment.has_been_edited.should be_false
  end 
  
  it "is_locked should be false by default" do
    comment.is_locked.should be_false
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

  it "number_of_comments should return the total number of comments attached properly with deletions" do
    comment.number_of_comments.should eq(1)
    leafComment = create(:comment)
    nodeComment = create(:comment)
    nodeComment.comments << leafComment
    comment.comments << nodeComment
    nodeComment.update_column(:is_removed, true)
    comment.number_of_comments.should eq(2)
  end
  
  it "original_commentable should return 1 if the comment has no replies" do
    leafComment = create(:comment)
    nodeComment = create(:comment)
    nodeComment.comments << leafComment
    comment.comments << nodeComment
    leafComment.original_commentable.should eq(DefaultObjects.discussion)
  end
  
  it "replies_locked? should return false when is_locked is false" do
    comment.replies_locked?.should be_false
  end 
  
  it "replies_locked? should return true when is_locked is true" do
    comment.is_locked = true
    comment.save!
    comment.replies_locked?.should be_true
  end 

  it "should not be allowed to be created if what you are commenting on is locked" do
    comment.is_locked = true
    comment.save!
    invalid_comment = build(:comment, :commentable_id => comment.id, :commentable_type => comment.class.to_s)
    invalid_comment.valid?.should be_false
  end
  
  describe "destroy" do
    it "should mark comment as deleted if comment has not subcomments" do
      comment.comments.empty?.should be_true
      comment.destroy
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_true
    end
    
    it "should mark comment as deleted if comment has only subcomments marked as is_removed" do
      comment = create(:comment_with_comment)
      comment.comments.count.should eq 1
      subcomment = comment.comments.first
      subcomment.update_column(:is_removed, true)
      
      comment.destroy
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_true
      Comment.exists?(subcomment).should be_false
      Comment.with_deleted.exists?(subcomment).should be_true
    end
    
    it "should mark comment as is_removed if comment has subcomments" do
      comment = create(:comment_with_comment)
      comment.comments.count.should eq 1
      
      comment.destroy
      Comment.exists?(comment).should be_true
      comment.reload.is_removed.should be_true
    end
  end
  
  describe "nuke" do
    it "should destroy comment" do
      comment.comments.empty?.should be_true
      comment.nuke
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_false
    end
    
    it "should destroy comment's comments" do
      comment = create(:comment_with_comment)
      comment.comments.count.should eq 1
      subcomment = comment.comments.first
      
      comment.nuke
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_false
      Comment.exists?(subcomment).should be_false
      Comment.with_deleted.exists?(subcomment).should be_false
    end
  end
end
