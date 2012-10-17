require 'spec_helper'

describe CardController do
  let(:user) { DefaultObjects.user }

  describe "GET 'edit'" do
    it "returns http success" do
      sign_in user
      get 'edit'
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "returns http success" do
      sign_in user
      put 'update'
      response.should be_success
    end
  end

end
