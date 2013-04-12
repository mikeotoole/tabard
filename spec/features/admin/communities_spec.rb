require 'spec_helper'

describe "ActiveAdmin Community" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:community) { DefaultObjects.community }

  before(:each) do
    set_host "lvh.me:3000"
  end

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_communities_url
      page.status_code.should == 200
      current_url.should == alexandria_communities_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_communities_url
      page.status_code.should == 200
      current_url.should == alexandria_communities_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_communities_url
      page.status_code.should == 200
      current_url.should == alexandria_communities_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_communities_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_communities_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_community_url(:id => community.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_url(:id => community.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_community_url(:id => community.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_url(:id => community.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_community_url(:id => community.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_url(:id => community.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_community_url(:id => community.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_community_url(:id => community.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#destroy" do
    it "deletes community when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/communities/#{community.id}")
      Community.exists?(community).should be_false
    end

    it "deletes community when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/communities/#{community.id}")
      Community.exists?(community).should be_false
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/communities/#{community.id}")
      Community.exists?(community).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/communities/#{community.id}")
      Community.exists?(community).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete community when not logged in" do
      page.driver.delete("/alexandria/communities/#{community.id}")
      Community.exists?(community).should be_true
    end
  end
end