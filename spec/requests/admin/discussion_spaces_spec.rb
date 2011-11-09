require 'spec_helper'

describe "ActiveAdmin DiscussionSpace" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:discussion_space) { DefaultObjects.discussion_space }
  let(:discussion_space_att) { attributes_for(:discussion_space, :name => "Test Case Name") }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_discussion_spaces_url
      page.status_code.should == 200
      current_url.should == admin_discussion_spaces_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_discussion_spaces_url
      page.status_code.should == 200
      current_url.should == admin_discussion_spaces_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_discussion_spaces_url
      page.status_code.should == 200
      current_url.should == admin_discussion_spaces_url
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

      visit admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 200
      current_url.should == admin_discussion_space_url(:id => discussion_space.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 200
      current_url.should == admin_discussion_space_url(:id => discussion_space.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 200
      current_url.should == admin_discussion_space_url(:id => discussion_space.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_discussion_space_url(:id => discussion_space.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#new" do 
    it "raises error ActionNotFound" do
      lambda { visit new_admin_discussion_space_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end

  describe "#edit" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 200
      current_url.should == edit_admin_discussion_space_url(:id => discussion_space.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 200
      current_url.should == edit_admin_discussion_space_url(:id => discussion_space.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit edit_admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 200
      current_url.should == edit_admin_discussion_space_url(:id => discussion_space.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_discussion_space_url(:id => discussion_space.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_discussion_space_url(:id => discussion_space.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/discussion_spaces") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#update" do 
    it "updates discussion_space when logged in as superadmin" do
      login_as superadmin
      page.driver.put("/admin/discussion_spaces/#{discussion_space.id}", { :discussion_space => { :name => "test_case_name" } } )
      DiscussionSpace.find(discussion_space).name.should eql "test_case_name"
    end 
    
    it "updates discussion_space when logged in as admin" do
      login_as admin
      page.driver.put("/admin/discussion_spaces/#{discussion_space.id}", { :discussion_space => { :name => "test_case_name" } } )
      DiscussionSpace.find(discussion_space).name.should eql "test_case_name"
    end    
    
    it "updates discussion_space when logged in as moderator" do
      login_as moderator
      page.driver.put("/admin/discussion_spaces/#{discussion_space.id}", { :discussion_space => { :name => "test_case_name" } } )
      DiscussionSpace.find(discussion_space).name.should eql "test_case_name"
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user
      
      original_name = discussion_space.name
      page.driver.put("/admin/discussion_spaces/#{discussion_space.id}", { :discussion_space => { :name => "test_case_name" } } )
      DiscussionSpace.find(discussion_space).name.should eql original_name
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not update discussion_space when not logged in" do
      original_name = discussion_space.name
      page.driver.put("/admin/discussion_spaces/#{discussion_space.id}", { :discussion_space => { :name => "test_case_name" } } )
      DiscussionSpace.find(discussion_space).name.should eql original_name
    end   
  end

  describe "#destroy" do
    it "deletes discussion_space when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/discussion_spaces/#{discussion_space.id}")
      DiscussionSpace.exists?(discussion_space).should be_false
    end 
    
    it "deletes discussion_space when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/discussion_spaces/#{discussion_space.id}")
      DiscussionSpace.exists?(discussion_space).should be_false
    end    
    
    it "deletes discussion_space when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/discussion_spaces/#{discussion_space.id}")
      DiscussionSpace.exists?(discussion_space).should be_false
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/discussion_spaces/#{discussion_space.id}")
      DiscussionSpace.exists?(discussion_space).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete discussion_space when not logged in" do
      page.driver.delete("/admin/discussion_spaces/#{discussion_space.id}")
      DiscussionSpace.exists?(discussion_space).should be_true
    end      
  end

end