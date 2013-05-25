require 'spec_helper'

describe CommunityInvitesController do
  let(:community) { create(:community) }
  let(:admin_user) { community.admin_profile.user }
  let(:applicant) { create(:user_profile) }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "POST 'create'" do
    it "should create with good attributes" do
      sign_in admin_user
      post 'create', community_invite: {sponsor_id: admin_user.user_profile.id, applicant_id: applicant.id, community_id: community.id}
      response.should redirect_to applicant
    end
  end
end

