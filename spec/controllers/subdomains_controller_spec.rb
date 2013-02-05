require 'spec_helper'

describe SubdomainsController do
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:community) { create(:community) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET 'index'" do
    it "should show the homepage for the admin" do
      sign_in community.admin_profile.user
      get 'index'
      response.should be_success
    end

    it "should redirect to root url when authenticated as a user" do
      sign_in user
      get 'index'
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'index'
      response.should be_success
    end

    it "should redirect to root if not exist" do
      @request.host = "DOESNOTEXIST.example.com"
      sign_in community.admin_profile.user
      get 'index'
      response.should redirect_to(root_url(subdomain: false))
    end

    describe "deliquent_account" do
      before(:each) do
        community.admin_profile.user.mark_as_delinquent_account
      end
      it "should redirect if deliquent_account if no user" do
        get 'index'
        response.should redirect_to(community_disabled_url)
      end
      it "should redirect to roster assignments for admin" do
        sign_in community.admin_profile.user
        get 'index'
        response.should redirect_to(roster_assignments_url(subdomain: community.subdomain))
      end
    end
  end
end
