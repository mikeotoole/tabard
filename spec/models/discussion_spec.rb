# == Schema Information
#
# Table name: discussions
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  body                :text
#  discussion_space_id :integer
#  character_proxy_id  :integer
#  user_profile_id     :integer
#  is_locked           :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  deleted_at          :datetime
#  has_been_edited     :boolean          default(FALSE)
#  character_id        :integer
#

require 'spec_helper'

describe Discussion do
  let(:comment) { create(:comment) }
  let(:discussion) { create(:discussion) }
  let(:user_profile) { DefaultObjects.user_profile }
  let(:wow_character) { create(:wow_character) }
  let(:wow_discussion) { create(:discussion_by_wow_character, character_id: wow_character.id, user_profile_id: wow_character.user_profile.id) }
  let(:billy) { create(:billy) }

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

  it "poster should return the user profile when there is no character" do
    discussion.poster.should eq(DefaultObjects.user_profile)
  end

  it "poster should return the character when there is a character" do
    wow_discussion.poster.should be_a_kind_of(WowCharacter)
  end

  it "charater_posted? should return false when there is no character" do
    discussion.charater_posted?.should be_false
  end

  it "charater_posted? should return true when there is a character" do
    wow_discussion.charater_posted?.should be_true
  end

  it "number_of_comments should return 0 if the discussion has no comments" do
    discussion.comments.should be_empty
    discussion.number_of_comments.should eq(0)
  end

  it "number_of_comments should return the total number of comments attached" do
    comment = create(:comment, :commentable_id => discussion.id)
    comment.number_of_comments.should eq(1)
    nodeComment = FactoryGirl.create(:comment, :commentable_id => comment.id, :commentable_type => "Comment")
    comment.comments << nodeComment
    comment.number_of_comments.should eq(2)
    leafComment = FactoryGirl.create(:comment, :commentable_id => nodeComment.id, :commentable_type => "Comment")
    nodeComment.comments << leafComment
    nodeComment.number_of_comments.should eq(2)
    comment.number_of_comments.should eq(3)
    discussion.number_of_comments.should eq(3)
  end

  it "update_viewed(user_profile) should create view_log for user_profile if it does not exist" do
    discussion.view_logs.should be_empty
    discussion.update_viewed(user_profile)
    log = Discussion.find(discussion).view_logs.first
    log.should be_a(ViewLog)
    log.user_profile.should eq(user_profile)
  end

  it "update_viewed(user_profile) should update view_log modified time for user_profile if it exists" do
    Timecop.freeze(1.day.ago)
    discussion.view_logs.should be_empty
    discussion.update_viewed(user_profile)
    Discussion.find(discussion).view_logs.count.should eq(1)
    org_log = Discussion.find(discussion).view_logs.first
    org_log.should be_a(ViewLog)
    Timecop.return
    discussion.update_viewed(user_profile)
    Discussion.find(discussion).view_logs.count.should eq(1)
    updated_log = Discussion.find(discussion).view_logs.first
    org_log.updated_at.should_not eql updated_log.updated_at
  end

  it "should respond to view_logs" do
    discussion.should respond_to(:view_logs)
  end

  describe "character_is_valid_for_user_profile" do
    it "should allow a user's character" do
      build(:discussion, :discussion_space_id => DefaultObjects.general_discussion_space.id,
          :user_profile_id => billy.user_profile_id,
          :character_id => billy.characters.first.id).should be_valid
    end
    it "should not allow a non user's character" do
      another_user_profile = create(:user_profile_with_characters)
      invalid_character = another_user_profile.characters.first
      build(:discussion, :discussion_space_id => DefaultObjects.general_discussion_space.id,
          :user_profile_id => billy.user_profile_id,
          :character_id => invalid_character.id).should_not be_valid
    end
  end

  describe "destroy" do
    it "should mark discussion as deleted" do
      discussion.destroy
      Discussion.exists?(discussion).should be_false
      Discussion.with_deleted.exists?(discussion).should be_true
    end

    it "should mark discussion's view logs as deleted" do
      view_log = create(:view_log)
      discussion = view_log.view_loggable
      discussion.should be_a(Discussion)
      discussion.destroy
      ViewLog.exists?(view_log).should be_false
      ViewLog.with_deleted.exists?(view_log).should be_true
    end

    it "should mark all comments as deleted" do
      comment = create(:comment_with_comment)
      comment_comment = comment.comments.first
      discussion = comment.commentable
      discussion.should be_a(Discussion)
      discussion.destroy
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_true
      Comment.exists?(comment_comment).should be_false
      Comment.with_deleted.exists?(comment_comment).should be_true
    end
  end

  describe "nuke" do
    it "should delete discussion" do
      discussion.nuke
      Discussion.exists?(discussion).should be_false
      Discussion.with_deleted.exists?(discussion).should be_false
    end

    it "should delete discussion's view logs" do
      view_log = create(:view_log)
      discussion = view_log.view_loggable
      discussion.should be_a(Discussion)
      discussion.nuke
      ViewLog.exists?(view_log).should be_false
      ViewLog.with_deleted.exists?(view_log).should be_false
    end

    it "should delete all comments" do
      comment = create(:comment_with_comment)
      comment_comment = comment.comments.first
      discussion = comment.commentable
      discussion.should be_a(Discussion)
      discussion.nuke
      Comment.exists?(comment).should be_false
      Comment.with_deleted.exists?(comment).should be_false
      Comment.exists?(comment_comment).should be_false
      Comment.with_deleted.exists?(comment_comment).should be_false
    end
  end
end
