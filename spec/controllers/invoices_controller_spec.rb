require 'spec_helper'

describe InvoicesController do
  let(:user) { DefaultObjects.user }
  let(:invoice) { user.current_invoice }

  describe "GET 'index'" do
    it "returns http success for logged in user" do
      sign_in user
      get 'index'
      response.should be_success
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get "index"
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "GET 'show'" do
    it "returns http success for logged in user" do
      sign_in user
      get 'show', id: invoice
      pending "Add an invoice to the seed"
      response.should be_success
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get 'show', id: invoice
      pending "Add an invoice to the seed"
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end
end
