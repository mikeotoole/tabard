require 'spec_helper'

describe CardController do
  let(:user) { DefaultObjects.user }

  describe "GET 'edit'" do
    it "returns http success for logged in user" do
      sign_in user
      get 'edit'
      response.should be_success
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get "edit"
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "PUT 'update'" do
    it "returns http success for logged in user" do
      sign_in user
      put 'update', stripe_card_token: "tok_jOq0M8vJprCUUU"
      response.should be_success
    end
    it "should redirected to new user session path when not authenticated as a user" do
      put 'update'
      response.should redirect_to(new_user_session_url)
    end
  end

end
