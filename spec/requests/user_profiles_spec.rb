require 'spec_helper'

describe UserProfilesController do
  let(:non_owner) { create(:billy) }
  let(:owner) { create(:user) }
  let(:user_profile) { owner.user_profile }
  let(:private_owner) { create(:user, :user_profile_attributes => FactoryGirl.attributes_for(:user_profile, :publicly_viewable => false)) }
  let(:private_user_profile) { private_owner.user_profile }

  describe "GET 'show'" do
    describe "user_profile is publicly viewable" do
      it "show should be successful when authenticated as the owner" do
        login_as owner
        visit user_profile_url(user_profile)
        page.should have_selector('ol.activities')
      end

      it "show should be successful when authenticated as a non-owner" do
        login_as non_owner
        visit user_profile_url(user_profile)
        page.should have_selector('ol.activities')
      end

      it "should be successful when not authenticated as a user when user_profile is publicly viewable" do
        visit user_profile_url(user_profile)
        page.should have_selector('ol.activities')
      end
    end
    describe "user_profile is not publicly viewable" do
      it "show should show activities when authenticated as the owner" do
        pending
        #login_as private_owner
        #visit user_profile_url(private_user_profile)
        #page.should have_selector('ol.activities')
      end

      it "show should not show activities when authenticated as a non-owner" do
        login_as non_owner
        visit user_profile_url(private_user_profile)
        page.should_not have_selector('ol.activities')
      end

      it "should not show activities when not authenticated as a user when user_profile is publicly viewable" do
        visit user_profile_url(private_user_profile)
        page.should_not have_selector('ol.activities')
      end
    end
  end
end