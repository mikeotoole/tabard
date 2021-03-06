require 'spec_helper'

describe InvoicesController do
  let(:invoice) { create(:invoice) }
  let(:user) { invoice.user }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "GET 'index'" do
    it "returns http success for logged in user" do
      sign_in user
      get 'index'
      response.should be_success
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get "index"
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET 'show'" do
    it "returns http success for logged in user" do
      sign_in user
      get 'show', id: invoice
      response.should be_success
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get 'show', id: invoice
      response.should redirect_to(new_user_session_url)
    end
  end
end
