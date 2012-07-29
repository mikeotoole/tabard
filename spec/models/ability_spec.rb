# == Schema Information
#
# Table name: answers
#
#  id            :integer         not null, primary key
#  body          :text
#  question_id   :integer
#  submission_id :integer
#  created_at    :datetime
#  updated_at    :datetime
#

require 'spec_helper'
require "cancan/matchers"

describe Ability do
  ###
  # Here is a quick example to writing tests for cancan using the magical cancan matcher:
  #
  # Create some user => user = User.create!
  #   * This would most likely be the factory of your choice.
  #
  # Next you create cancan ability.
  # ability = Ability.new(user)
  #
  # Then you can test what they can and can't do:
  # ability.should be_able_to(:destroy, Project.new(:user => user))
  # ability.should_not be_able_to(:destroy, Project.new)
  #
  ###
  describe "for an anonymous user" do
    before(:each) do
      @user = User.new
      @ability = Ability.new(@user)
    end
    it "can create an account" do
      @ability.should be_able_to(:create, User.new)
    end

    describe "Anonymous Permissions" do
      before(:each) do
        @ability = Ability.new(@user)
      end
      describe "Community" do
        it "should allow read" do
          public_community = create(:community)
          @ability.should be_able_to(:read, public_community)
        end
      end
      describe "Game" do
        it "should allow read" do
          @ability.should be_able_to(:read, Game)
        end
      end
      describe "User" do
        it "should be able to create user" do
          @ability.should be_able_to(:create, User)
        end
      end
      describe "UserProfile" do
        it "should be able to read public profiles" do
          @ability.should be_able_to(:read, create(:user_profile, :publicly_viewable => true))
        end
        it "should be able to read non public profiles" do
          @ability.should be_able_to(:read, create(:user_profile, :publicly_viewable => false))
        end
      end
    end
    #In the scope of a community they are treated as a non member, with the exception that they can not apply to a community.
  end

  describe "for a site member" do
    before(:each) do
      if not PrivacyPolicy.first and not TermsOfService.first
        FactoryGirl.create(:privacy_policy)
        FactoryGirl.create(:terms_of_service)
      end
      @user = create(:user_profile).user
      @ability = Ability.new(@user)
    end
    it "should be a valid user" do
      @user.persisted?.should be_true
    end
    describe "Anonymous Permissions" do
      before(:each) do
        @ability = Ability.new(@user)
      end
      describe "Community" do
        it "should allow read" do
          public_community = create(:community)
          @ability.should be_able_to(:read, public_community)
        end
      end
      describe "Game" do
        it "should allow read" do
          @ability.should be_able_to(:read, Game)
        end
      end
      describe "User" do
        it "should be able to create user" do
          @ability.should be_able_to(:create, User)
        end
      end
      describe "UserProfile" do
        it "should be able to read public profiles" do
          @ability.should be_able_to(:read, create(:user_profile, :publicly_viewable => true))
        end
        it "should be able to read non public profiles" do
          @ability.should be_able_to(:read, create(:user_profile, :publicly_viewable => false))
        end
      end
    end
 
    describe "Site Member Permissions" do
      before(:each) do
        @ability = Ability.new(@user)
      end

      it "should be a valid user" do
        @user.persisted?.should be_true
      end
    
      describe "Discussion" do
        it "should be able to update a owned discussion" do
          @ability.should be_able_to(:update, build(:discussion, :user_profile_id => @user.user_profile_id))
        end
        it "should be able to destroy a owned discussion" do
          @ability.should be_able_to(:destroy, build(:discussion, :user_profile_id => @user.user_profile_id))
        end
      end

      describe "Comment" do
        before(:each) do
          @comment = Comment.new
          @comment.user_profile = @user.user_profile
        end
        # Comment Rules
        it "should be able to update a comment they own" do
          @ability.should be_able_to(:update, @comment)
        end
        it "should be able to destroy a comment they own" do
          @ability.should be_able_to(:destroy, @comment)
        end
      end

      describe "Community" do
        it "should be able to create a community" do
          @ability.should be_able_to(:create, Community)
        end
      end

      describe "CommunityApplication" do
        before(:each) do
          @community_application = CommunityApplication.new
          @community_application.user_profile_id = @user.user_profile.id
        end
        it "should be able to create an application they own" do
          @ability.should be_able_to(:create, @community_application)
        end
        it "should be able to destroy an application they own" do
          @ability.should be_able_to(:destroy, @community_application)
        end
        it "should be able to uodate an application they own" do
          @ability.should be_able_to(:update, @community_application)
        end
        it "should not be able to show an application they own" do
          @ability.should_not be_able_to(:show, @community_application)
        end
      end

      describe "Discussion" do
        before(:each) do
          @discussion = Discussion.new
          @discussion.user_profile = @user.user_profile
        end
        describe "not locked" do
          before(:each) do
            @discussion.is_locked = false
          end
          it "should be able to update an discussion they own" do
            @ability.should be_able_to(:update, @discussion)
          end
          it "should be able to destroy an discussion they own" do
            @ability.should be_able_to(:destroy, @discussion)
          end
        end
        describe "locked" do
          before(:each) do
            @discussion.is_locked = true
          end
          it "should be able to update an discussion they own" do
            @ability.should_not be_able_to(:update, @discussion)
          end
          it "should be able to destroy an discussion they own" do
            @ability.should_not be_able_to(:destroy, @discussion)
          end
        end
      end
      describe "DiscussionSpace" do
        before(:each) do
          @discussion_space = DiscussionSpace.new
          @discussion_space.is_announcement_space == true
        end
        it "should not be able to update an announcement discussion space" do
          @ability.should_not be_able_to(:update, @discussion_space)
        end
        it "should not be able to destroy an announcement discussion space" do
          @ability.should_not be_able_to(:destroy, @discussion_space)
        end
        it "should not be able to create an announcement discussion space" do
          @ability.should_not be_able_to(:create, @discussion_space)
        end
      end
      describe "Messaging" do
        before(:each) do
          @folder = Folder.new
          @folder.user_profile = @user.user_profile
          @message = Message.new
          @message.author = @user.user_profile
          @message_association = MessageAssociation.new
          @message_association.recipient = @user.user_profile
        end
        describe "Folder" do
          it "should allow management of folders" do
            @ability.should be_able_to(:manage, @folder)
          end
          it "should not allow deletion of folders" do
            @ability.should_not be_able_to(:destroy, @folder)
          end
        end
        describe "Message" do
          it "should allow management of messages" do
            @ability.should be_able_to(:manage, @message)
          end
          it "should not allow deletion of messages" do
            @ability.should_not be_able_to(:destroy, @message)
          end
          it "should not allow update of messages" do
            @ability.should_not be_able_to(:update, @message)
          end
        end 
        describe "Message Association" do
          it "should allow management of message associations" do
            @ability.should be_able_to(:manage, @message_association)
          end
        end
      end
      
      describe "Question" do
        it "should allow reading of questions" do
          @ability.should be_able_to(:read, Question)
        end
      end

      describe "Submission" do
        before(:each) do
          @submission = Submission.new
          @submission.user_profile = @user.user_profile
        end
        it "should allow creation of submissions" do
          @ability.should be_able_to(:create, Submission)
        end
        it "should allow read of owned submissions" do
          @ability.should be_able_to(:read, @submission)
        end
        it "should allow destroy of owned submissions" do
          @ability.should be_able_to(:destroy, @submission)
        end
      end
      describe "User" do
        it "should allow management of the current user" do
          @ability.should be_able_to(:manage, @user)
        end
      end

      describe "User Profile" do
        it "should allow read of user profiles" do
          @ability.should be_able_to(:read, UserProfile)
        end
        it "should allow update of current user profile" do
          @ability.should be_able_to(:update, @user.user_profile)
        end
      end
    end
  end
end
