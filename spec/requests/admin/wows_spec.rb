require 'spec_helper'

describe "ActiveAdmin Wow" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }

  let(:wow) { DefaultObjects.wow }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_wows_url
      page.status_code.should == 200
      current_url.should == admin_wows_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_wows_url
      page.status_code.should == 200
      current_url.should == admin_wows_url
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_wows_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_wows_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end

    it "redirects to login page when not logged in" do
      visit admin_wows_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_wow_url(:id => wow.id)
      page.status_code.should == 200
      current_url.should == admin_wow_url(:id => wow.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_wow_url(:id => wow.id)
      page.status_code.should == 200
      current_url.should == admin_wow_url(:id => wow.id)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_wow_url(:id => wow.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_wow_url(:id => wow.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_wow_url(:id => wow.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#new" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit new_admin_wow_url
      page.status_code.should == 200
      current_url.should == new_admin_wow_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit new_admin_wow_url
      page.status_code.should == 200
      current_url.should == new_admin_wow_url
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_admin_wow_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_admin_wow_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end 
    
    it "redirects to login page when not logged in" do
      visit new_admin_wow_url
      current_path.should == new_admin_user_session_path
    end   
  end

  describe "#edit" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_wow_url(:id => wow.id)
      page.status_code.should == 200
      current_url.should == edit_admin_wow_url(:id => wow.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_admin_wow_url(:id => wow.id)
      page.status_code.should == 200
      current_url.should == edit_admin_wow_url(:id => wow.id)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_admin_wow_url(:id => wow.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_wow_url(:id => wow.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_wow_url(:id => wow.id)
      current_path.should == new_admin_user_session_path
    end        
  end

  describe "#create" do
    it "creates Wow when logged in as superadmin" do
      login_as superadmin
      expect {
        page.driver.post("/admin/wows", { :wow => attributes_for(:wow, :server => "test_server") } )
      }.to change(Wow, :count).by(1)
    end 
    
    it "creates Wow when logged in as admin" do
      login_as admin
      expect {
        page.driver.post("/admin/wows", { :wow => attributes_for(:wow, :server => "test_server") } )
      }.to change(Wow, :count).by(1)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator
      expect {
        page.driver.post("/admin/wows", { :wow => attributes_for(:wow, :server => "test_server") } )
      }.to change(Wow, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user
      expect {
        page.driver.post("/admin/wows", { :wow => attributes_for(:wow, :server => "test_server") } )
      }.to change(Wow, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not create Wow when not logged in" do
      expect {
        page.driver.post("/admin/wows", { :wow => attributes_for(:wow, :server => "test_server") } )
      }.to change(Wow, :count).by(0)
    end    
  end

  describe "#update" do 
    it "updates Wow when logged in as superadmin" do
      login_as superadmin
      
      page.driver.put("/admin/wows/#{wow.id}", { :wow => { :server_name => "test_case_server" } } )
      Wow.find(wow).server_name.should eql "test_case_server"
    end
    
    it "updates Wow when logged in as admin" do
      login_as admin
      
      page.driver.put("/admin/wows/#{wow.id}", { :wow => { :server_name => "test_case_server" } } )
      Wow.find(wow).server_name.should eql "test_case_server"
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      orginal_server = wow.server_name
      page.driver.put("/admin/wows/#{wow.id}", { :wow => { :server_name => "test_case_server" } } )
      Wow.find(wow).server_name.should eql orginal_server
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      orginal_server = wow.server_name
      page.driver.put("/admin/wows/#{wow.id}", { :wow => { :server_name => "test_case_server" } } )
      Wow.find(wow).server_name.should eql orginal_server
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not update Wow when not logged in" do
      orginal_server = wow.server_name
      page.driver.put("/admin/wows/#{wow.id}", { :wow => { :server_name => "test_case_server" } } )
      Wow.find(wow).server_name.should eql orginal_server
    end   
  end
 
  describe "#destroy" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.delete("/admin/wows/#{wow.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end
end
