require 'spec_helper'

describe "ActiveAdmin SupportedGame" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:supported_game) { create(:supported_game) }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_supported_games_url
      page.status_code.should == 200
      current_url.should == admin_supported_games_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_supported_games_url
      page.status_code.should == 200
      current_url.should == admin_supported_games_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_supported_games_url
      page.status_code.should == 200
      current_url.should == admin_supported_games_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_supported_games_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_supported_games_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 200
      current_url.should == admin_supported_game_url(:id => supported_game.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 200
      current_url.should == admin_supported_game_url(:id => supported_game.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 200
      current_url.should == admin_supported_game_url(:id => supported_game.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_supported_game_url(:id => supported_game.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#new" do 
    it "raises error ActionNotFound" do
      lambda { visit new_admin_supported_game_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end

  describe "#edit" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 200
      current_url.should == edit_admin_supported_game_url(:id => supported_game.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 200
      current_url.should == edit_admin_supported_game_url(:id => supported_game.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit edit_admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 200
      current_url.should == edit_admin_supported_game_url(:id => supported_game.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_supported_game_url(:id => supported_game.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_supported_game_url(:id => supported_game.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/supported_games") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#update" do 
    it "updates supported_game when logged in as superadmin" do
      login_as superadmin
      page.driver.put("/admin/supported_games/#{supported_game.id}", { :supported_game => { :name => "test_case_name", 
                                                                                            :faction => supported_game.faction, 
                                                                                            :server_name => supported_game.server_name } } )
      SupportedGame.find(supported_game).name.should eql "test_case_name"
    end 
    
    it "updates supported_game when logged in as admin" do
      login_as admin
      page.driver.put("/admin/supported_games/#{supported_game.id}", { :supported_game => { :name => "test_case_name", 
                                                                                            :faction => supported_game.faction, 
                                                                                            :server_name => supported_game.server_name } } )
      SupportedGame.find(supported_game).name.should eql "test_case_name"
    end    
    
    it "updates supported_game when logged in as moderator" do
      login_as moderator
      page.driver.put("/admin/supported_games/#{supported_game.id}", { :supported_game => { :name => "test_case_name", 
                                                                                            :faction => supported_game.faction, 
                                                                                            :server_name => supported_game.server_name } } )
      SupportedGame.find(supported_game).name.should eql "test_case_name"
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user
      
      original_name = supported_game.name
      page.driver.put("/admin/supported_games/#{supported_game.id}", { :supported_game => { :name => "test_case_name", 
                                                                                            :faction => supported_game.faction, 
                                                                                            :server_name => supported_game.server_name } } )
      SupportedGame.find(supported_game).name.should eql original_name
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not update supported_game when not logged in" do
      original_name = supported_game.name
      page.driver.put("/admin/supported_games/#{supported_game.id}", { :supported_game => { :name => "test_case_name", 
                                                                                            :faction => supported_game.faction, 
                                                                                            :server_name => supported_game.server_name } } )
      SupportedGame.find(supported_game).name.should eql original_name
    end   
  end

  describe "#destroy" do
    it "deletes supported_game when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/supported_games/#{supported_game.id}")
      SupportedGame.exists?(supported_game).should be_false
    end 
    
    it "deletes supported_game when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/supported_games/#{supported_game.id}")
      SupportedGame.exists?(supported_game).should be_false
    end    
    
    it "deletes supported_game when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/supported_games/#{supported_game.id}")
      SupportedGame.exists?(supported_game).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/supported_games/#{supported_game.id}")
      SupportedGame.exists?(supported_game).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete supported_game when not logged in" do
      page.driver.delete("/admin/supported_games/#{supported_game.id}")
      SupportedGame.exists?(supported_game).should be_true
    end      
  end

end