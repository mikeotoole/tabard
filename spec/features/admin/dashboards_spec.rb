require 'spec_helper'

describe "ActiveAdmin Dashboard" do
 let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }

  before(:each) do
    set_host "lvh.me:3000"
  end

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_dashboard_url
      page.status_code.should == 200
      current_url.should == alexandria_dashboard_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_dashboard_url
      page.status_code.should == 200
      current_url.should == alexandria_dashboard_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_dashboard_url
      page.status_code.should == 200
      current_url.should == alexandria_dashboard_url
    end

    it "redirects to login page when not logged in" do
      visit alexandria_dashboard_url
      current_path.should == new_admin_user_session_path
    end
  end

end