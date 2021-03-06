require 'spec_helper'

describe "ActiveAdmin Character" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:character) { create(:swtor_character) }

  before(:each) do
    set_host "lvh.me:3000"
  end

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_characters_url
      page.status_code.should == 200
      current_url.should == alexandria_characters_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_characters_url
      page.status_code.should == 200
      current_url.should == alexandria_characters_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_characters_url
      page.status_code.should == 200
      current_url.should == alexandria_characters_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_characters_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_characters_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == alexandria_character_url(:id => character.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == alexandria_character_url(:id => character.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_character_url(:id => character.id)
      page.status_code.should == 200
      current_url.should == alexandria_character_url(:id => character.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_character_url(:id => character.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_character_url(:id => character.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#destroy" do
    it "deletes character when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/characters/#{character.id}")
      Character.exists?(character).should be_false
    end

    it "deletes character when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/characters/#{character.id}")
      Character.exists?(character).should be_false
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/characters/#{character.id}")
      Character.exists?(character).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/characters/#{character.id}")
      Character.exists?(character).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete character when not logged in" do
      page.driver.delete("/alexandria/characters/#{character.id}")
      Character.exists?(character).should be_true
    end
  end
end
