require 'spec_helper'

describe "ActiveAdmin Question" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:question) { create(:short_answer_question) }
  let(:predefined_answer) { create(:check_box_question).predefined_answers.first }

  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_questions_url
      page.status_code.should == 200
      current_url.should == admin_questions_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_questions_url
      page.status_code.should == 200
      current_url.should == admin_questions_url
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_questions_url
      page.status_code.should == 200
      current_url.should == admin_questions_url
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_questions_url
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_questions_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_question_url(:id => question.id)
      page.status_code.should == 200
      current_url.should == admin_question_url(:id => question.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_question_url(:id => question.id)
      page.status_code.should == 200
      current_url.should == admin_question_url(:id => question.id)
    end    
    
    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit admin_question_url(:id => question.id)
      page.status_code.should == 200
      current_url.should == admin_question_url(:id => question.id)
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_question_url(:id => question.id)
      page.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_question_url(:id => question.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_admin_question_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/questions") }.should raise_error(AbstractController::ActionNotFound)
    end
  end 

  describe "#edit" do
    it "raises error ActionNotFound" do
      lambda { visit edit_admin_question_url(:id => question.id) }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#update" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/admin/questions/#{question.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end

  describe "#destroy" do
    it "deletes question when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/questions/#{question.id}")
      Question.exists?(question).should be_false
    end 
    
    it "deletes question when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/questions/#{question.id}")
      Question.exists?(question).should be_false
    end    
    
    it "deletes question when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/questions/#{question.id}")
      Question.exists?(question).should be_false
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/questions/#{question.id}")
      Question.exists?(question).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete question when not logged in" do
      page.driver.delete("/admin/questions/#{question.id}")
      Question.exists?(question).should be_true
    end      
  end

  describe "#delete_predefined_answer_admin_question" do 
    it "deletes predefined answer when logged in as superadmin" do
      login_as superadmin

      page.driver.put("/admin/questions/#{predefined_answer.id}/delete_predefined_answer")
      PredefinedAnswer.exists?(predefined_answer).should be_false
    end 
    
    it "deletes predefined answer when logged in as admin" do
      login_as admin

      page.driver.put("/admin/questions/#{predefined_answer.id}/delete_predefined_answer")
      PredefinedAnswer.exists?(predefined_answer).should be_false
    end    
    
    it "deletes predefined answer when logged in as moderator" do
      login_as moderator

      page.driver.put("/admin/questions/#{predefined_answer.id}/delete_predefined_answer")
      PredefinedAnswer.exists?(predefined_answer).should be_false
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/admin/questions/#{predefined_answer.id}/delete_predefined_answer")
      PredefinedAnswer.exists?(predefined_answer).should be_true
      page.driver.status_code.should == 403
      page.should have_content('forbidden')
    end
    
    it "does not delete predefined answer when not logged in" do
      page.driver.put("/admin/questions/#{predefined_answer.id}/delete_predefined_answer")
      PredefinedAnswer.exists?(predefined_answer).should be_true
    end    
  end  

end