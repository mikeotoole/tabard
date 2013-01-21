require 'spec_helper'

describe "ActiveAdmin UserProfile" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:user_profile) { DefaultObjects.user_profile }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_user_profiles_url
      page.status_code.should == 200
      current_url.should == alexandria_user_profiles_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_user_profiles_url
      page.status_code.should == 200
      current_url.should == alexandria_user_profiles_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_user_profiles_url
      page.status_code.should == 200
      current_url.should == alexandria_user_profiles_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_user_profiles_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_user_profiles_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_user_profile_url(:id => user_profile.id)
      page.status_code.should == 200
      current_url.should == alexandria_user_profile_url(:id => user_profile.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_user_profile_url(:id => user_profile.id)
      page.status_code.should == 200
      current_url.should == alexandria_user_profile_url(:id => user_profile.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_user_profile_url(:id => user_profile.id)
      page.status_code.should == 200
      current_url.should == alexandria_user_profile_url(:id => user_profile.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_user_profile_url(:id => user_profile.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_user_profile_url(:id => user_profile.id)
      current_path.should == new_admin_user_session_path
    end
  end

end