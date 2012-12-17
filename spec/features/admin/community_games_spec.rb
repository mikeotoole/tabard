require 'spec_helper'

describe "ActiveAdmin CommunityGame" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:community_game) { create(:community_game) }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_community_games_url
      page.status_code.should == 200
      current_url.should == alexandria_community_games_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_community_games_url
      page.status_code.should == 200
      current_url.should == alexandria_community_games_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_community_games_url
      page.status_code.should == 200
      current_url.should == alexandria_community_games_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_community_games_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_community_games_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_community_game_url(:id => community_game.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_game_url(:id => community_game.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_community_game_url(:id => community_game.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_game_url(:id => community_game.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_community_game_url(:id => community_game.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_game_url(:id => community_game.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_community_game_url(:id => community_game.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_community_game_url(:id => community_game.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_alexandria_community_game_url }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit edit_alexandria_community_game_url(:id => community_game.id) }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#update" do
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/alexandria/community_games/#{community_game.id}") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/alexandria/community_games") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#destroy" do
    it "deletes community_game when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/community_games/#{community_game.id}")
      CommunityGame.exists?(community_game).should be_false
    end

    it "deletes community_game when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/community_games/#{community_game.id}")
      CommunityGame.exists?(community_game).should be_false
    end

    it "deletes community_game when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/community_games/#{community_game.id}")
      CommunityGame.exists?(community_game).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/community_games/#{community_game.id}")
      CommunityGame.exists?(community_game).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete community_game when not logged in" do
      page.driver.delete("/alexandria/community_games/#{community_game.id}")
      CommunityGame.exists?(community_game).should be_true
    end
  end

end