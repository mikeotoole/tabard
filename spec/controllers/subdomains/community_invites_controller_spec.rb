require 'spec_helper'

describe Subdomains::CommunityInvitesController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET 'index'" do
    it "returns http success for someone with permissions" do
      sign_in admin
      get 'index'
      response.should be_success
    end
    it "fail for someone without permissions" do
      sign_in non_member
      get 'index'
      response.should be_forbidden
    end
  end

  it "fail for someone without permissions" do
    sign_in non_member
    get 'index'
    response.should be_forbidden
  end
end
