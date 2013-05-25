require 'spec_helper'

describe SupportTicketsController do
  let(:user) { create(:user) }
  let(:user_profile) { user.user_profile }
  let(:support_ticket) { create(:support_ticket, user_profile: user_profile)  }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "GET 'index'" do
    it "should show the index" do
      sign_in user
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should show" do
      sign_in user
      get 'show', id: support_ticket.id
      response.should be_success
    end
    it "should show extra flash if admin is working on it" do
      support_ticket.admin_user = create(:admin_user)
      support_ticket.save
      sign_in user
      get 'show', id: support_ticket.id
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should create with good attributes" do
      sign_in user
      post 'create', support_ticket: attributes_for(:support_ticket, user_profile: user_profile)
      response.should_not redirect_to(support_index_url)
    end
    it "should not create with bad attributes" do
      sign_in user
      post 'create', support_ticket: attributes_for(:support_ticket, user_profile: user_profile, body: "")
      response.should redirect_to(support_index_url)
    end
  end

  describe "PUT 'status'" do
    it "should create with good attributes" do
      sign_in user
      put 'status', id: support_ticket.id, status: "Closed"
      response.should redirect_to(support_index_url)
    end
    it "should not create with bad attributes" do
      sign_in user
      put 'status', id: support_ticket.id, status: "flksad;lfjasldfj;lsadjflkajsdlfjsldfjlasdlfk"
      response.should redirect_to(support_index_url)
    end
  end
end

