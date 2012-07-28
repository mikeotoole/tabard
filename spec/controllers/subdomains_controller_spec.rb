require 'spec_helper'

describe SubdomainsController do
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:community) { create(:community) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET 'index'" do
    it "should redirect to root url when authenticated as a user" do
      sign_in user
      get 'index'
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'index'
      response.should be_success
    end
  end
end