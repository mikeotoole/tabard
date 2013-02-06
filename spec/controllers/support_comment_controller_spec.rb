require 'spec_helper'

describe SupportCommentsController do
  let(:user) { create(:user) }
  let(:user_profile) { user.user_profile }
  let(:support_ticket) { create(:support_ticket, user_profile: user_profile)  }
  let(:support_comment) { create(:support_comment, user_profile: user_profile) }

  describe "POST 'create'" do
    it "should create with good attributes" do
      sign_in user
      post 'create', support_id: support_ticket, support_comment: attributes_for(:support_comment, support_ticket: support_ticket)
      response.should redirect_to(support_url(support_ticket))
    end
    it "should not create with bad attributes" do
      sign_in user
      post 'create', support_id: support_ticket, support_comment: attributes_for(:support_comment, support_ticket: support_ticket, body: "")
      response.should_not redirect_to(support_url(support_ticket))
    end
  end
end

