require 'spec_helper'

describe TopLevelController do
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end
#   describe "GET 'intro'" do
#     it "should be successful" do
#       get 'intro'
#       response.should be_success
#     end
#   end
  describe "GET 'features'" do
    it "should be successful" do
      get 'features'
      response.should be_success
    end
  end
  describe "GET 'maintenance'" do
    it "should be redirect when not in maintenance mode" do
      get 'maintenance'
      response.should redirect_to(root_url)
    end
  end
  describe "GET 'pricing'" do
    it "should be successful" do
      get 'pricing'
      response.should be_success
    end
  end
  describe "GET 'privacy_policy'" do
    it "should be successful" do
      get 'privacy_policy'
      response.should be_success
    end
  end
  describe "GET 'terms_of_service'" do
    it "should be successful" do
      get 'terms_of_service'
      response.should be_success
    end
  end
  describe "GET 'trademark-disclaimer'" do
    it "should be successful" do
      get 'trademark_disclaimer'
      response.should be_success
    end
  end
end
