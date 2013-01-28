require 'spec_helper'

describe "Communities" do
  let(:billy) { create(:billy) }
  describe "new" do
    it "should be accessable if signed in" do
      login_as(billy, :scope => :user)
      visit new_community_url(subdomain: "secure")
      page.should have_content("Create a Community")
      page.should_not have_content("Sign in")
    end
    it "should not be accessable if signed in" do
      visit new_community_url(subdomain: "secure")
      page.should_not have_content("Create a Community")
      page.should have_content("Sign in")
    end
    it "should create a new one and go to the setting page", js: true do
      set_host "lvh.me:1337"
      login_as(billy, :scope => :user)
      visit new_community_url(subdomain: "secure")
      fill_in "Community name", with: "herp"
      page.driver.render('screenshots/community.png', full: true)
      click_button "Create Community"
      page.driver.render('screenshots/community2.png', full: true)
      page.should have_content("Community Settings")
    end
  end

end
