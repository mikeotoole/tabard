require 'spec_helper'

describe "Communities" do
  let(:billy) { create(:billy) }
  describe "new" do
    it "should be accessable if signed in" do
      login_as(billy, :scope => :user)
      visit new_community_url
      page.should have_content("Create a Community")
      page.should_not have_content("Sign in")
    end
    it "should not be accessable if signed in" do
      visit new_community_url
      page.should_not have_content("Create a Community")
      page.should have_content("Sign in")
    end
  end
end
