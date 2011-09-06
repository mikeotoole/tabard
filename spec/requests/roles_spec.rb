require 'spec_helper'

describe "Roles" do
  describe "GET /roles" do
    it "should display all roles for the community" do
      user = Factory(:user)
      community = Factory(:community, :admin_profile => user.user_profile)
      visit community_path(community)
    end
  end
end
