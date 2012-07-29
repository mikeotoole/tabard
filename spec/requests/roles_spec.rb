require 'spec_helper'

describe "Roles" do
  before(:each) do
    @admin = create(:user)
    @admin_profile = create(:user_profile, :user => @admin)
    @theme = create :theme, :name => 'Guild.io'
    @community = create(:community, :admin_profile => @admin_profile)
  end
  describe "GET /roles" do
    it "should display all roles for the community" do
      visit community_url(@community)
    end
  end
end
