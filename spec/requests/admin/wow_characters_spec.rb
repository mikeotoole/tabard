require 'spec_helper'

describe "ActiveAdmin WowCharacter" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:character) { create(:wow_character) }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_wow_characters_url
      page.status_code.should == 200
      current_url.should == admin_wow_characters_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_wow_characters_url
      page.status_code.should == 200
      current_url.should == admin_wow_characters_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_wow_characters_url
      page.status_code.should == 200
      current_url.should == admin_wow_characters_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_wow_characters_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_wow_characters_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_wow_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == admin_wow_character_url(:id => character.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_wow_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == admin_wow_character_url(:id => character.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_wow_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == admin_wow_character_url(:id => character.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_wow_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_wow_character_url(:id => character.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#new" do 
    it "returns 403 when logged in as superadmin" do
      login_as superadmin

      visit new_admin_wow_character_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit new_admin_wow_character_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_admin_wow_character_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_admin_wow_character_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit new_admin_wow_character_url
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#edit" do 
    it "returns 403 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_wow_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit edit_admin_wow_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_admin_wow_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_wow_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_wow_character_url(:id => character.id)
      current_path.should == new_admin_user_session_path
    end    
  end

end