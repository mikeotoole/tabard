require 'spec_helper'

describe SiteConfigurationController do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "PUT toggle_maintenance_mode" do
    it "redirects all traffic when logged in as superadmin" do
      controller.stub!(:current_admin_user).and_return(superadmin)
      put :toggle_maintenance_mode

      visit root_url
      current_url.should == top_level_maintenance_url

      put :toggle_maintenance_mode

      visit root_url
      current_url.should == root_url
    end

    it "redirects all traffic when logged in as admin" do
      controller.stub!(:current_admin_user).and_return(admin)
      put :toggle_maintenance_mode

      visit root_url
      current_url.should == top_level_maintenance_url

      put :toggle_maintenance_mode

      visit root_url
      current_url.should == root_url
    end

    it "does not redirect all traffic when logged in as moderator" do
      controller.stub!(:current_admin_user).and_return(moderator)
      put :toggle_maintenance_mode

      visit root_url
      current_url.should == root_url
    end

    it "does not redirect all traffic when logged in as regular User" do
      controller.stub!(:current_admin_user).and_return(user)
      put :toggle_maintenance_mode

      visit root_url
      current_url.should == root_url
    end

    it "does not redirect all traffic when not logged in" do
      put :toggle_maintenance_mode

      visit root_url
      current_url.should == root_url
    end
  end
end
