require 'spec_helper'

describe DocumentAcceptanceController do
  let(:privacy_policy) { create(:privacy_policy) }
  let(:user) { DefaultObjects.user }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "GET 'new'" do
    it "returns http success" do
      sign_in user
      get :new, :id => privacy_policy
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "POST 'create'" do
    it "redirects_to user profile characters tab, if user accepts" do
      sign_in user
      post :create, :id => privacy_policy, :accept => true
      response.should redirect_to(user_profile_url(user.user_profile))
    end
    it "redirects if they have already accepted it" do
      sign_in user
      post :create, :id => privacy_policy
      response.should redirect_to(accept_document_url(privacy_policy))
    end
  end

end
