require 'spec_helper'

describe "ActiveAdmin Community" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:community) { DefaultObjects.community }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_communities_url
      page.status_code.should == 200
      current_url.should == admin_communities_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_communities_url
      page.status_code.should == 200
      current_url.should == admin_communities_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_communities_url
      page.status_code.should == 200
      current_url.should == admin_communities_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_communities_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_communities_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_community_url(:id => community.id)
      page.status_code.should == 200
      current_url.should == admin_community_url(:id => community.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_community_url(:id => community.id)
      page.status_code.should == 200
      current_url.should == admin_community_url(:id => community.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_community_url(:id => community.id)
      page.status_code.should == 200
      current_url.should == admin_community_url(:id => community.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_community_url(:id => community.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_community_url(:id => community.id)
      current_path.should == new_admin_user_session_path
    end     
  end
  
  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_admin_community_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end
 
  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/communities") }.should raise_error(AbstractController::ActionNotFound)
    end
  end 

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit edit_admin_community_url(:id => community.id) }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#update" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/admin/communities/#{community.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#destroy" do
    it "deletes community when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/communities/#{community.id}")
      Community.exists?(community).should be_false
    end 
    
    it "deletes community when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/communities/#{community.id}")
      Community.exists?(community).should be_false
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/communities/#{community.id}")
      Community.exists?(community).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/communities/#{community.id}")
      Community.exists?(community).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "does not delete community when not logged in" do
      page.driver.delete("/admin/communities/#{community.id}")
      Community.exists?(community).should be_true
    end      
  end  
end