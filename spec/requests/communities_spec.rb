require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
describe "Communities" do
  let(:billy) { create(:billy) }
  describe "new" do
    it "should be accessable if signed in" do
      login_as(billy, :scope => :user)
      visit new_community_url(subdomain: "secure")
      page.should have_content("Create a Community")
      Warden.test_reset!
    end
    it "should not be accessable if signed in" do
      visit new_community_url(subdomain: "secure")
      page.should_not have_content("Create a Community")
    end
  end

end
