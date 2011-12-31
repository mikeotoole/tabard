require 'spec_helper'

describe Subdomains::CommunityProfilesController do
  let(:owner) { DefaultObjects.user }
  let(:non_owner) { 
    profile = create(:user_profile)
    DefaultObjects.community.promote_user_profile_to_member(profile)
    profile.user
  }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }
  let(:community_profile) { create(:page) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "DELETE destroy" do
    it "destroys the community profile when authenticated as admin" do
      page
      sign_in admin
      expect {
        delete :destroy, :id => community_profile.id.to_s
      }.to change(CommunityProfile, :count).by(-1)
    end

    it "redirects to the roster assignements url when authenticated an admin" do
      sign_in admin
      delete :destroy, :id => community_profile.id.to_s
      response.should redirect_to(roster_assignments_url)
    end
    
    it "should respond forbidden when authenticated as member" do
      sign_in non_member
      delete :destroy, :id => page.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      delete :destroy, :id => page.id.to_s
      response.should be_forbidden
    end
  end

end
