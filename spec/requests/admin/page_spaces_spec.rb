require 'spec_helper'

describe "ActiveAdmin PageSpace" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:page_space) { DefaultObjects.page_space }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_page_spaces_url
      page.status_code.should == 200
      current_url.should == admin_page_spaces_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_page_spaces_url
      page.status_code.should == 200
      current_url.should == admin_page_spaces_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_page_spaces_url
      page.status_code.should == 200
      current_url.should == admin_page_spaces_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_discussion_spaces_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_discussion_spaces_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == admin_page_space_url(:id => page_space.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == admin_page_space_url(:id => page_space.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == admin_page_space_url(:id => page_space.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_page_space_url(:id => page_space.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_page_space_url(:id => page_space.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#new" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit new_admin_page_space_url
      page.status_code.should == 200
      current_url.should == new_admin_page_space_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit new_admin_page_space_url
      page.status_code.should == 200
      current_url.should == new_admin_page_space_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit new_admin_page_space_url
      page.status_code.should == 200
      current_url.should == new_admin_page_space_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_admin_discussion_space_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit new_admin_discussion_space_url
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#edit" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == edit_admin_page_space_url(:id => page_space.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_admin_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == edit_admin_page_space_url(:id => page_space.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit edit_admin_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == edit_admin_page_space_url(:id => page_space.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_page_space_url(:id => page_space.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_page_space_url(:id => page_space.id)
      current_path.should == new_admin_user_session_path
    end    
  end

end