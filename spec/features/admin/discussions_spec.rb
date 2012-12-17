require 'spec_helper'

describe "ActiveAdmin Discussion" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:comment) { create(:comment) }
  let(:discussion) { comment.commentable }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_discussions_url
      page.status_code.should == 200
      current_url.should == alexandria_discussions_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_discussions_url
      page.status_code.should == 200
      current_url.should == alexandria_discussions_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_discussions_url
      page.status_code.should == 200
      current_url.should == alexandria_discussions_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_discussions_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_discussions_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_discussion_url(:id => discussion.id)
      page.status_code.should == 200
      current_url.should == alexandria_discussion_url(:id => discussion.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_discussion_url(:id => discussion.id)
      page.status_code.should == 200
      current_url.should == alexandria_discussion_url(:id => discussion.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_discussion_url(:id => discussion.id)
      page.status_code.should == 200
      current_url.should == alexandria_discussion_url(:id => discussion.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_discussion_url(:id => discussion.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_discussion_url(:id => discussion.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_alexandria_discussion_url }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/alexandria/discussions") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit visit edit_alexandria_discussion_url(:id => discussion.id) }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#update" do
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/alexandria/discussions/#{discussion.id}") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#destroy" do
    it "deletes discussion when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/discussions/#{discussion.id}")
      Discussion.exists?(discussion).should be_false
    end

    it "deletes discussion when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/discussions/#{discussion.id}")
      Discussion.exists?(discussion).should be_false
    end

    it "deletes discussion when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/discussions/#{discussion.id}")
      Discussion.exists?(discussion).should be_false
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/discussions/#{discussion.id}")
      Discussion.exists?(discussion).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete discussion when not logged in" do
      page.driver.delete("/alexandria/discussions/#{discussion.id}")
      Discussion.exists?(discussion).should be_true
    end
  end

  describe "#remove_comment_alexandria_discussion" do
    it "deletes comment when logged in as superadmin" do
      login_as superadmin

      page.driver.put("/alexandria/discussions/#{comment.id}/remove_comment")
      Comment.exists?(comment).should be_false
    end

    it "deletes comment when logged in as admin" do
      login_as admin

      page.driver.put("/alexandria/discussions/#{comment.id}/remove_comment")
      Comment.exists?(comment).should be_false
    end

    it "deletes comment when logged in as moderator" do
      login_as moderator

      page.driver.put("/alexandria/discussions/#{comment.id}/remove_comment")
      Comment.exists?(comment).should be_false
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/alexandria/discussions/#{comment.id}/remove_comment")
      Comment.exists?(comment).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete comment when not logged in" do
      page.driver.put("/alexandria/discussions/#{comment.id}/remove_comment")
      Comment.exists?(comment).should be_true
    end
  end

end