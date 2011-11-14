require 'spec_helper'

describe "ActiveAdmin User" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:user_2) { DefaultObjects.fresh_user_profile.user }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_users_url
      page.status_code.should == 200
      current_url.should == admin_users_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_users_url
      page.status_code.should == 200
      current_url.should == admin_users_url
    end
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_users_url
      page.status_code.should == 200
      current_url.should == admin_users_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_users_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_users_url
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_user_url(:id => user.id)
      page.status_code.should == 200
      current_url.should == admin_user_url(:id => user.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_user_url(:id => user.id)
      page.status_code.should == 200
      current_url.should == admin_user_url(:id => user.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_user_url(:id => user.id)
      page.status_code.should == 200
      current_url.should == admin_user_url(:id => user.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_user_url(:id => user.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_user_url(:id => user.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_admin_user_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end
 
  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/users") }.should raise_error(AbstractController::ActionNotFound)
    end
  end 

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit edit_admin_user_url(:id => user.id) }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#update" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/admin/users/#{user.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#destroy" do
    it "deletes user when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/users/#{user.id}")
      User.exists?(user).should be_false
    end 
    
    it "deletes user when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/users/#{user.id}")
      User.exists?(user).should be_false
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/users/#{user.id}")
      User.exists?(user).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/users/#{user.id}")
      User.exists?(user).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete user when not logged in" do
      page.driver.delete("/admin/users/#{user.id}")
      User.exists?(user).should be_true
    end      
  end

  describe "#suspend" do 
    before(:each) do
      user.suspended.should be_false
    end

    it "suspends user when logged in as superadmin" do
      login_as superadmin
      
      page.driver.put("/admin/users/#{user.id}/suspend")
      User.find(user).suspended.should be_true
    end 
    
    it "suspends user when logged in as admin" do
      login_as admin

      page.driver.put("/admin/users/#{user.id}/suspend")
      User.find(user).suspended.should be_true
    end    
    
    it "suspends user when logged in as moderator" do
      login_as moderator

      page.driver.put("/admin/users/#{user.id}/suspend")
      User.find(user).suspended.should be_true
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/admin/users/#{user.id}/suspend") 
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
      User.find(user).suspended.should be_false
    end
    
    it "does not suspend user when not logged in" do
      page.driver.put("/admin/users/#{user.id}/suspend")
      User.find(user).suspended.should be_false
    end
  end  

  describe "#reinstate" do
    before(:each) do
      user.suspended = true
      user.save!
      user.suspended.should be_true
    end
  
    it "reinstates user when logged in as superadmin" do
      login_as superadmin
      
      page.driver.put("/admin/users/#{user.id}/reinstate")
      User.find(user).suspended.should be_false
    end 
    
    it "reinstates user when logged in as admin" do
      login_as admin

      page.driver.put("/admin/users/#{user.id}/reinstate")
      User.find(user).suspended.should be_false
    end    
    
    it "reinstates user when logged in as moderator" do
      login_as moderator

      page.driver.put("/admin/users/#{user.id}/reinstate")
      User.find(user).suspended.should be_false
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user_2

      page.driver.put("/admin/users/#{user.id}/reinstate")
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
      User.find(user).suspended.should be_true
    end
    
    it "does not reinstate user when not logged in" do
      page.driver.put("/admin/users/#{user.id}/reinstate")
      User.find(user).suspended.should be_true
    end
  end

  describe "#reset_password" do
    before(:each) do
      user.reset_password_token.should be_nil
    end
   
    it "resets password when logged in as superadmin" do
      login_as superadmin
      
      password = user.encrypted_password
      page.driver.put("/admin/users/#{user.id}/reset_password")
      User.find(user).reset_password_token.should_not be_nil
      User.find(user).encrypted_password.should_not eql password
    end 
    
    it "resets password when logged in as admin" do
      login_as admin

      password = user.encrypted_password
      page.driver.put("/admin/users/#{user.id}/reset_password")
      User.find(user).reset_password_token.should_not be_nil
      User.find(user).encrypted_password.should_not eql password
    end    
    
    it "resets password when logged in as moderator" do
      login_as moderator

      password = user.encrypted_password
      page.driver.put("/admin/users/#{user.id}/reset_password")
      User.find(user).reset_password_token.should_not be_nil
      User.find(user).encrypted_password.should_not eql password
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      password = user.encrypted_password
      page.driver.put("/admin/users/#{user.id}/reset_password")
      page.driver.status_code.should eql 403
      User.find(user).reset_password_token.should be_nil
      User.find(user).encrypted_password.should eql password
      page.should have_content('forbidden')
    end
    
    it "does not reset password when not logged in" do
      password = user.encrypted_password
      page.driver.put("/admin/users/#{user.id}/reset_password")
      User.find(user).reset_password_token.should be_nil
      User.find(user).encrypted_password.should eql password
    end
  end
  
  describe "#reset_all_passwords" do
    before(:each) do
      user
      user_2
      User.all.each do |this_user|
        this_user.reset_password_token.should be_nil
      end
    end
   
    it "resets all passwords when logged in as superadmin" do
      login_as superadmin

      page.driver.post("/admin/users/reset_all_passwords")
      User.all.each do |this_user|
        this_user.reset_password_token.should_not be_nil
      end
    end 
    
    it "resets all passwords when logged in as admin" do
      login_as admin

      page.driver.post("/admin/users/reset_all_passwords")
      User.all.each do |this_user|
        this_user.reset_password_token.should_not be_nil
      end
    end    
    
    it "resets all passwords when logged in as moderator" do
      login_as moderator

      page.driver.post("/admin/users/reset_all_passwords")
      User.all.each do |this_user|
        this_user.reset_password_token.should be_nil
      end
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.post("/admin/users/reset_all_passwords")
      User.all.each do |this_user|
        this_user.reset_password_token.should be_nil
      end
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
    end
    
    it "does not reset all passwords when not logged in" do
      page.driver.post("/admin/users/reset_all_passwords")
      User.all.each do |this_user|
        this_user.reset_password_token.should be_nil
      end
    end
  end
  
  describe "#sign_out_all_users" do 
    before(:each) do
      user
      user_2
      User.all.each do |this_user|
        this_user.force_logout.should be_false
      end
    end

    it "sets force_logout when logged in as superadmin" do
      login_as superadmin

      page.driver.post("/admin/users/sign_out_all_users")
      User.all.each do |this_user|
        this_user.force_logout.should be_true
      end
    end 
    
    it "sets force_logout when logged in as admin" do
      login_as admin

      page.driver.post("/admin/users/sign_out_all_users")
      User.all.each do |this_user|
        this_user.force_logout.should be_true
      end
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.post("/admin/users/sign_out_all_users")
      User.all.each do |this_user|
        this_user.force_logout.should be_false
      end
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.post("/admin/users/sign_out_all_users")
      User.all.each do |this_user|
        this_user.force_logout.should be_false
      end
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
    end
    
    it "does not set force_logout when not logged in" do
      page.driver.post("/admin/users/sign_out_all_users")
      User.all.each do |this_user|
        this_user.force_logout.should be_false
      end
    end
  end  
end