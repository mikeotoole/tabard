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

    it "redirects to login page when not logged in" do
      visit admin_admin_users_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do 
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
    
    it "redirects to login page when not logged in" do
      visit admin_admin_user_url(:id => admin.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#new" do 
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
    
    it "redirects to login page when not logged in" do
      visit new_admin_admin_user_url
      current_path.should == new_admin_user_session_path
    end   
  end

  describe "#edit" do 
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
    
    it "redirects to login page when not logged in" do
      visit edit_admin_admin_user_url(:id => admin.id)
      current_path.should == new_admin_user_session_path
    end        
  end

  describe "#create" do
    it "creates AdminUser when logged in as superadmin" do
      login_as superadmin
      expect {
        page.driver.post("/admin/admin_users", { :admin_user => attributes_for(:admin_user) } )
      }.to change(AdminUser, :count).by(1)
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin
      expect {
        page.driver.post("/admin/admin_users", { :admin_user => attributes_for(:admin_user) } )
      }.to change(AdminUser, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator
      expect {
        page.driver.post("/admin/admin_users", { :admin_user => attributes_for(:admin_user) } )
      }.to change(AdminUser, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user
      expect {
        page.driver.post("/admin/admin_users", { :admin_user => attributes_for(:admin_user) } )
      }.to change(AdminUser, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not create AdminUser when not logged in" do
      expect {
        page.driver.post("/admin/admin_users", { :admin_user => attributes_for(:admin_user) } )
      }.to change(AdminUser, :count).by(0)
    end    
  end

  describe "#update" do 
    it "updates AdminUser when logged in as superadmin" do
      login_as superadmin
      page.driver.put("/admin/admin_users/#{admin.id}", { :admin_user => { :email => "test_case_eamil@example.com" } } )
      AdminUser.find(admin).email.should eql "test_case_eamil@example.com"
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin
      orginal_email = moderator.email
      page.driver.put("/admin/admin_users/#{moderator.id}", { :admin_user => { :email => "test_case_eamil@example.com" } } )
      AdminUser.find(moderator).email.should eql orginal_email
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator
      orginal_email = admin.email
      page.driver.put("/admin/admin_users/#{admin.id}", { :admin_user => { :email => "test_case_eamil@example.com" } } )
      AdminUser.find(admin).email.should eql orginal_email
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user
      orginal_email = moderator.email
      page.driver.put("/admin/admin_users/#{moderator.id}", { :admin_user => { :email => "test_case_eamil@example.com" } } )
      AdminUser.find(moderator).email.should eql orginal_email
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not update AdminUser when not logged in" do
      orginal_email = admin.email
      page.driver.put("/admin/admin_users/#{admin.id}", { :admin_user => { :email => "test_case_eamil@example.com" } } )
      AdminUser.find(admin).email.should eql orginal_email
    end   
  end

  describe "#destroy" do
    it "deletes AdminUser when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/admin_users/#{admin.id}")
      AdminUser.exists?(admin).should be_false
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/admin_users/#{moderator.id}")
      AdminUser.exists?(moderator).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/admin_users/#{admin.id}")
      AdminUser.exists?(admin).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/admin_users/#{admin.id}")
      AdminUser.exists?(admin).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete AdminUser when not logged in" do
      page.driver.delete("/admin/admin_users/#{admin.id}")
      AdminUser.exists?(admin).should be_true
    end      
  end
  
  describe "#edit_account" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_account_admin_admin_users_url
      page.status_code.should == 200
      current_url.should == edit_account_admin_admin_users_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_account_admin_admin_users_url
      page.status_code.should == 200
      current_url.should == edit_account_admin_admin_users_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit edit_account_admin_admin_users_url
      page.status_code.should == 200
      current_url.should == edit_account_admin_admin_users_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_account_admin_admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_account_admin_admin_users_url
      current_path.should == new_admin_user_session_path
    end 
  end

  describe "#update_account" do
    it "changes password and email when logged in as superadmin" do
      login_as superadmin   
      
      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "Password", :email => "test-case-email@example.com", :password => "NewPassword", :password_confirmation => "NewPassword" } } )
      page.driver.status_code.should == 200   
    end 
    
    it "changes password and email when logged in as admin" do
      login_as admin

      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "Password", :email => "test-case-email@example.com", :password => "NewPassword", :password_confirmation => "NewPassword" } } )
      page.driver.status_code.should == 200
    end    
    
    it "changes password and email when logged in as moderator" do
      login_as moderator

      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "Password", :email => "test-case-email@example.com", :password => "NewPassword", :password_confirmation => "NewPassword" } } )
      page.driver.status_code.should == 200
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "Password", :email => "test-case-email@example.com", :password => "NewPassword", :password_confirmation => "NewPassword" } } )
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "Password", :email => "test-case-email@example.com", :password => "NewPassword", :password_confirmation => "NewPassword" } } )

      page.driver.status_code.should == 302
    end

    it "redirects back to edit when current_password is wrong" do
      login_as admin
  
      old_email = admin.email
      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "WrongPassword", :email => "test-case-email@example.com" } } )
      page.driver.status_code.should == 200
      
      AdminUser.find(admin).email.should eql old_email
    end
    
    it "does not allow changing of role" do
      login_as moderator

      page.driver.put("/admin/admin_users/update_account", { :admin_user => { :current_password => "Password", :email => "test-case-email@example.com", :password => "NewPassword", :password_confirmation => "NewPassword", :role => "superadmin" } } )
      page.driver.status_code.should == 200
      
      AdminUser.find(moderator).role.should eql "moderator"
    end
  end

  describe "#reset_password_admin_admin_user" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin
      
      password = admin.encrypted_password
      page.driver.put("/admin/admin_users/#{admin.id}/reset_password")
      AdminUser.find(admin).encrypted_password.should_not eql password
      AdminUser.find(admin).reset_password_token.should_not be_nil
    end 
    
    it "returns 403 when logged in as admin" do   
      login_as admin

      page.driver.put("/admin/admin_users/#{moderator.id}/reset_password")
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
      AdminUser.find(moderator).reset_password_token.should be_nil
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.put("/admin/admin_users/#{admin.id}/reset_password")
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
      AdminUser.find(admin).reset_password_token.should be_nil
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/admin/admin_users/#{admin.id}/reset_password")
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
      AdminUser.find(admin).reset_password_token.should be_nil
    end
    
    it "Does not reset_password when not logged in" do
      page.driver.put("/admin/admin_users/#{admin.id}/reset_password")
      AdminUser.find(admin).reset_password_token.should be_nil
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
    
    it "redirects to login page when not logged in" do
      visit reset_all_passwords_admin_admin_users_url
      current_path.should == new_admin_user_session_path
    end
  end
end
