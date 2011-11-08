require 'spec_helper'

describe "ActiveAdmin CustomForm" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:question) { custom_form.questions.first }
  let(:custom_form) { create(:custom_form_w_questions) }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_custom_forms_url
      page.status_code.should == 200
      current_url.should == admin_custom_forms_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_custom_forms_url
      page.status_code.should == 200
      current_url.should == admin_custom_forms_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_custom_forms_url
      page.status_code.should == 200
      current_url.should == admin_custom_forms_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_custom_forms_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_custom_forms_url
      current_path.should == new_admin_user_session_path
    end   
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 200
      current_url.should == admin_custom_form_url(:id => custom_form.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 200
      current_url.should == admin_custom_form_url(:id => custom_form.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 200
      current_url.should == admin_custom_form_url(:id => custom_form.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_custom_form_url(:id => custom_form.id)
      current_path.should == new_admin_user_session_path
    end
  end
  
  describe "#new" do 
    it "returns 403 when logged in as superadmin" do
      login_as superadmin

      visit new_admin_custom_form_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit new_admin_custom_form_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_admin_custom_form_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_admin_custom_form_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit new_admin_custom_form_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#edit" do 
    it "returns 403 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end 
    
    it "returns 403 when logged in as admin" do
      login_as admin

      visit edit_admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_custom_form_url(:id => custom_form.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_custom_form_url(:id => custom_form.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#delete_question_admin_custom_form" do
    it "deletes question when logged in as superadmin" do
      login_as superadmin

      page.driver.put("/admin/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_false
    end 
    
    it "deletes question when logged in as admin" do
      login_as admin

      page.driver.put("/admin/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_false
    end    
    
    it "deletes question when logged in as moderator" do
      login_as moderator

      page.driver.put("/admin/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_false
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/admin/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_true
      page.driver.status_code.should eql 403
      page.should have_content('forbidden')
    end
    
    it "does not delete question when not logged in" do
      page.driver.put("/admin/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_true
    end   
  end  

end