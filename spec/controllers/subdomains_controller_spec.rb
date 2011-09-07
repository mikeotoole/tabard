require 'spec_helper'

describe SubdomainsController do
  let(:user) { Factory.create(:user) }

  # TODO Joe, Are this tests right? When should it redirect to subdomain?
  describe "GET 'index'" do
    it "should redirect to root url when authenticated as a user" do
      sign_in user
      get 'index'
      response.should redirect_to(root_url)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get 'index'
      response.should redirect_to(root_url)
    end
  end
end