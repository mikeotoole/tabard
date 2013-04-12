require 'spec_helper'

describe "ActiveAdmin Document" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }

  let(:privacy_policy) { create(:privacy_policy) }
  let(:unpublished_privacy_policy) { create(:privacy_policy, :is_published => false) }
  let(:privacy_policy) { create(:privacy_policy) }
  let(:unpublished_terms_of_service) { create(:terms_of_service, :is_published => false) }

  before(:each) do
    set_host "lvh.me:3000"
  end

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_documents_url
      page.status_code.should == 200
      current_url.should == alexandria_documents_url
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit alexandria_documents_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit alexandria_documents_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_documents_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_documents_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin
      visit view_document_alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 200
      current_url.should == view_document_alexandria_document_url(:id => privacy_policy.id)
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_document_url(:id => privacy_policy.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#new" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit new_alexandria_document_url
      page.status_code.should == 200
      current_url.should == new_alexandria_document_url
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit new_alexandria_document_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_alexandria_document_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_alexandria_document_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit new_alexandria_document_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#edit" do
    it "returns 200 when logged in as superadmin and document has not been is_published" do
      login_as superadmin

      visit edit_alexandria_document_url(:id => unpublished_privacy_policy.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_document_url(:id => unpublished_privacy_policy.id)
    end

    it "returns 403 when logged in as superadmin and document has been is_published" do
      login_as superadmin
      privacy_policy.is_published.should be_true
      visit edit_alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit edit_alexandria_document_url(:id => unpublished_privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_alexandria_document_url(:id => unpublished_privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_alexandria_document_url(:id => unpublished_privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit edit_alexandria_document_url(:id => unpublished_privacy_policy.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#create" do
    it "creates Document when logged in as superadmin" do
      login_as superadmin
      expect {
        page.driver.post("/alexandria/documents", { :document => attributes_for(:privacy_policy, :type => "PrivacyPolicy") } )
      }.to change(Document, :count).by(1)
    end

    it "returns 403 when logged in as admin" do
      login_as admin
      expect {
        page.driver.post("/alexandria/documents", { :document => attributes_for(:privacy_policy, :type => "PrivacyPolicy") } )
      }.to change(Document, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator
      expect {
        page.driver.post("/alexandria/documents", { :document => attributes_for(:privacy_policy, :type => "PrivacyPolicy") } )
      }.to change(Document, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user
      expect {
        page.driver.post("/alexandria/documents", { :document => attributes_for(:privacy_policy, :type => "PrivacyPolicy") } )
      }.to change(Document, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not create Document when not logged in" do
      expect {
        page.driver.post("/alexandria/documents", { :document => attributes_for(:privacy_policy, :type => "PrivacyPolicy") } )
      }.to change(Document, :count).by(0)
    end
  end

  describe "#update" do
    it "updates Document when logged in as superadmin and document has not been is_published" do
      login_as superadmin
      page.driver.put("/alexandria/documents/#{unpublished_privacy_policy.id}", { :document => { :body => "test_case_body" } } )
      Document.find(unpublished_privacy_policy).body.should eql "test_case_body"
    end

    it "returns 403 when logged in as superadmin and document has been is_published" do
      login_as superadmin

      orginal_body = privacy_policy.body
      page.driver.put("/alexandria/documents/#{privacy_policy.id}", { :document => { :body => "test_case_body" } } )
      Document.find(privacy_policy).body.should eql orginal_body
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      orginal_body = unpublished_privacy_policy.body
      page.driver.put("/alexandria/documents/#{unpublished_privacy_policy.id}", { :document => { :body => "test_case_body" } } )
      Document.find(unpublished_privacy_policy).body.should eql orginal_body
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      orginal_body = unpublished_privacy_policy.body
      page.driver.put("/alexandria/documents/#{unpublished_privacy_policy.id}", { :document => { :body => "test_case_body" } } )
      Document.find(unpublished_privacy_policy).body.should eql orginal_body
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      orginal_body = unpublished_privacy_policy.body
      page.driver.put("/alexandria/documents/#{unpublished_privacy_policy.id}", { :document => { :body => "test_case_body" } } )
      Document.find(unpublished_privacy_policy).body.should eql orginal_body
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not update Document when not logged in" do
      orginal_body = unpublished_privacy_policy.body
      page.driver.put("/alexandria/documents/#{unpublished_privacy_policy.id}", { :document => { :body => "test_case_body" } } )
      Document.find(unpublished_privacy_policy).body.should eql orginal_body
    end
  end

  describe "#view_document" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit view_document_alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 200
      current_url.should == view_document_alexandria_document_url(:id => privacy_policy.id)
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit view_document_alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit view_document_alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit view_document_alexandria_document_url(:id => privacy_policy.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit view_document_alexandria_document_url(:id => privacy_policy.id)
      current_path.should == new_admin_user_session_path
    end
  end
end
