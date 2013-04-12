require 'spec_helper'

describe "ActiveAdmin CustomForm" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:custom_form) { create(:custom_form) }
  let(:question) { create(:short_answer_question) }

  before(:each) do
    set_host "lvh.me:3000"
  end

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_custom_forms_url
      page.status_code.should == 200
      current_url.should == alexandria_custom_forms_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_custom_forms_url
      page.status_code.should == 200
      current_url.should == alexandria_custom_forms_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_custom_forms_url
      page.status_code.should == 200
      current_url.should == alexandria_custom_forms_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_custom_forms_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_custom_forms_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_custom_form_url(:id => custom_form.id)
      page.status_code.should == 200
      current_url.should == alexandria_custom_form_url(:id => custom_form.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_custom_form_url(:id => custom_form.id)
      page.status_code.should == 200
      current_url.should == alexandria_custom_form_url(:id => custom_form.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_custom_form_url(:id => custom_form.id)
      page.status_code.should == 200
      current_url.should == alexandria_custom_form_url(:id => custom_form.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_custom_form_url(:id => custom_form.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_custom_form_url(:id => custom_form.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#destroy" do
    it "deletes custom_form when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_false
    end

    it "deletes custom_form when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_false
    end

    it "deletes custom_form when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_false
    end

    it "returns 403 if form is application form" do
      login_as superadmin
      app_custom_form = create(:community).community_application_form
      app_custom_form.application_form?.should be_true
      page.driver.delete("/alexandria/custom_forms/#{app_custom_form.id}")
      CustomForm.exists?(app_custom_form).should be_true
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete custom_form when not logged in" do
      page.driver.delete("/alexandria/custom_forms/#{custom_form.id}")
      CustomForm.exists?(custom_form).should be_true
    end
  end

  describe "#delete_question_alexandria_custom_form" do
    it "deletes question when logged in as superadmin" do
      login_as superadmin

      page.driver.put("/alexandria/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_false
    end

    it "deletes question when logged in as admin" do
      login_as admin

      page.driver.put("/alexandria/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_false
    end

    it "deletes question when logged in as moderator" do
      login_as moderator

      page.driver.put("/alexandria/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_false
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.put("/alexandria/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_true
      page.driver.status_code.should eql 403
      page.should have_content('Forbidden')
    end

    it "does not delete question when not logged in" do
      page.driver.put("/alexandria/custom_forms/#{question.id}/delete_question")
      Question.exists?(question).should be_true
    end
  end

end