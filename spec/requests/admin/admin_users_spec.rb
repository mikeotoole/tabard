require 'spec_helper'

describe "ActiveAdmin AdminUser" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_admin_users_url
      page.status_code.should == 200
      current_url.should == admin_admin_users_url
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
  end

  describe "#reset_password_admin_admin_user" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin
      
      visit reset_password_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 200
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit reset_password_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit reset_password_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit reset_password_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
  end
  
  describe "#reset_all_passwords_admin_admin_users" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_admin_users_url
      visit reset_all_passwords_admin_admin_users_url
      page.status_code.should == 200
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit reset_all_passwords_admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit reset_all_passwords_admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit reset_all_passwords_admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
  end  

  describe "#admin_admin_user" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_admin_user_url(:id => admin.id)
      page.status_code.should == 200
      current_url.should == admin_admin_user_url(:id => admin.id)
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
  end
  
  describe "#new_admin_admin_user" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit new_admin_admin_user_url
      page.status_code.should == 200
      current_url.should == new_admin_admin_user_url
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit new_admin_admin_user_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_admin_admin_user_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_admin_admin_user_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
  end

  describe "#edit_admin_admin_user" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 200
      current_url.should == edit_admin_admin_user_url(:id => admin.id)
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit edit_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_admin_user_url(:id => admin.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
  end
  
end
