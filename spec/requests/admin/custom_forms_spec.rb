require 'spec_helper'

describe "ActiveAdmin CustomForm" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:custom_form) { create(:custom_form) }
  let(:question) { create(:short_answer_question) }
 
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
    it "raises error ActionNotFound" do
      lambda { visit new_admin_custom_form_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end
 
  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/custom_forms") }.should raise_error(AbstractController::ActionNotFound)
    end
  end 

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit edit_admin_custom_form_url(:id => custom_form.id) }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#update" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/admin/custom_forms/#{custom_form.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#destroy" do
    it "deletes custom_form when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_false
    end 
    
    it "deletes custom_form when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_false
    end    
    
    it "deletes custom_form when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_false
    end
    
    it "returns 403 if form is application form" do
      login_as superadmin
      app_custom_form = create(:community).community_application_form
      app_custom_form.application_form?.should be_true
      page.driver.delete("/admin/custom_forms/#{app_custom_form.id}")
      CustomForm.exists?(app_custom_form).should be_true
    end
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete custom_form when not logged in" do
      page.driver.delete("/admin/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_true
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