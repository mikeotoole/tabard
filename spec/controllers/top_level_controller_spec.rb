require 'spec_helper'

describe TopLevelController do
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
  describe "GET 'pricing'" do
    it "should be successful" do
      get 'pricing'
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
