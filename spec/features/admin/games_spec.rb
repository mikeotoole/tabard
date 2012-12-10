require 'spec_helper'

describe "ActiveAdmin Game" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }

  let(:game) { DefaultObjects.swtor }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_games_url
      page.status_code.should == 200
      current_url.should == alexandria_games_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_games_url
      page.status_code.should == 200
      current_url.should == alexandria_games_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_games_url
      page.status_code.should == 200
      current_url.should == alexandria_games_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_games_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_games_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_game_url(:id => game.id)
      page.status_code.should == 200
      current_url.should == alexandria_game_url(:id => game.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_game_url(:id => game.id)
      page.status_code.should == 200
      current_url.should == alexandria_game_url(:id => game.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_game_url(:id => game.id)
      page.status_code.should == 200
      current_url.should == alexandria_game_url(:id => game.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_game_url(:id => game.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_game_url(:id => game.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#new" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit new_alexandria_game_url
      page.status_code.should == 200
      current_url.should == new_alexandria_game_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit new_alexandria_game_url
      page.status_code.should == 200
      current_url.should == new_alexandria_game_url
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_alexandria_game_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_alexandria_game_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit new_alexandria_game_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#edit" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_alexandria_game_url(:id => game.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_game_url(:id => game.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_alexandria_game_url(:id => game.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_game_url(:id => game.id)
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_alexandria_game_url(:id => game.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_alexandria_game_url(:id => game.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit edit_alexandria_game_url(:id => game.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#create" do
    it "creates game when logged in as superadmin" do
      login_as superadmin
      expect {
        page.driver.post("/alexandria/games", { :game => attributes_for(:swtor) } )
      }.to change(Game, :count).by(1)
    end

    it "creates game when logged in as admin" do
      login_as admin
      expect {
        page.driver.post("/alexandria/games", { :game => attributes_for(:swtor) } )
      }.to change(Game, :count).by(1)
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator
      expect {
        page.driver.post("/alexandria/games", { :game => attributes_for(:swtor) } )
      }.to change(Game, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user
      expect {
        page.driver.post("/alexandria/games", { :game => attributes_for(:swtor) } )
      }.to change(Game, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not create game when not logged in" do
      expect {
        page.driver.post("/alexandria/games", { :game => attributes_for(:swtor) } )
      }.to change(Game, :count).by(0)
    end
  end

  describe "#update" do
    it "updates game when logged in as superadmin" do
      login_as superadmin

      page.driver.put("/alexandria/games/#{game.id}", { :game => { :name => "test_case_name" } } )
      Game.find(game).name.should eql "test_case_name"
    end

    it "updates game when logged in as admin" do
      login_as admin

      page.driver.put("/alexandria/games/#{game.id}", { :game => { :name => "test_case_name" } } )
      Game.find(game).name.should eql "test_case_name"
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      orginal_name = game.name
      page.driver.put("/alexandria/games/#{game.id}", { :game => { :name => "test_case_name" } } )
      Game.find(game).name.should eql orginal_name
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      orginal_name = game.name
      page.driver.put("/alexandria/games/#{game.id}", { :game => { :name => "test_case_name" } } )
      Game.find(game).name.should eql orginal_name
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not update Wow when not logged in" do
      orginal_name = game.name
      page.driver.put("/alexandria/games/#{game.id}", { :game => { :name => "test_case_name" } } )
      Game.find(game).name.should eql orginal_name
    end
  end

  describe "#destroy" do
    it "raises error ActionNotFound" do
      lambda { page.driver.delete("/alexandria/games/#{game.id}") }.should raise_error(AbstractController::ActionNotFound)
    end
  end
end
