require 'spec_helper'

describe "ActiveAdmin Page" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:my_page) { create(:page) }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_pages_url
      page.status_code.should == 200
      current_url.should == alexandria_pages_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_pages_url
      page.status_code.should == 200
      current_url.should == alexandria_pages_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_pages_url
      page.status_code.should == 200
      current_url.should == alexandria_pages_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_pages_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_pages_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_page_url(:id => my_page.id)
      page.status_code.should == 200
      current_url.should == alexandria_page_url(:id => my_page.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_page_url(:id => my_page.id)
      page.status_code.should == 200
      current_url.should == alexandria_page_url(:id => my_page.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_page_url(:id => my_page.id)
      page.status_code.should == 200
      current_url.should == alexandria_page_url(:id => my_page.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_page_url(:id => my_page.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_page_url(:id => my_page.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#destroy" do
    it "deletes page when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/pages/#{my_page.id}")
      Page.exists?(my_page).should be_false
    end

    it "deletes page when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/pages/#{my_page.id}")
      Page.exists?(my_page).should be_false
    end

    it "deletes page when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/pages/#{my_page.id}")
      Page.exists?(my_page).should be_false
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/pages/#{my_page.id}")
      Page.exists?(my_page).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete page when not logged in" do
      page.driver.delete("/alexandria/pages/#{my_page.id}")
      Page.exists?(my_page).should be_true
    end
  end
end