require 'spec_helper'

describe "ActiveAdmin SwtorCharacter" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:character) { create(:swtor_char_profile) }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_swtor_characters_url
      page.status_code.should == 200
      current_url.should == admin_swtor_characters_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_swtor_characters_url
      page.status_code.should == 200
      current_url.should == admin_swtor_characters_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_swtor_characters_url
      page.status_code.should == 200
      current_url.should == admin_swtor_characters_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_swtor_characters_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_swtor_characters_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_swtor_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == admin_swtor_character_url(:id => character.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_swtor_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == admin_swtor_character_url(:id => character.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_swtor_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == admin_swtor_character_url(:id => character.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_swtor_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_swtor_character_url(:id => character.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_admin_swtor_character_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end
 
  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/swtor_characters") }.should raise_error(AbstractController::ActionNotFound)
    end
  end 

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit edit_admin_swtor_character_url(:id => character.id) }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#update" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/admin/swtor_characters/#{character.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#destroy" do
    it "deletes character when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/swtor_characters/#{character.id}")
      SwtorCharacter.find(character).is_removed.should be_true
    end 
    
    it "deletes character when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/swtor_characters/#{character.id}")
      SwtorCharacter.find(character).is_removed.should be_true
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/swtor_characters/#{character.id}")
      SwtorCharacter.exists?(character).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/swtor_characters/#{character.id}")
      SwtorCharacter.exists?(character).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete character when not logged in" do
      page.driver.delete("/admin/swtor_characters/#{character.id}")
      SwtorCharacter.exists?(character).should be_true
    end      
  end
end