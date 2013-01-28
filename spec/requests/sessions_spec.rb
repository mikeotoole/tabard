require 'spec_helper'

describe "Sessions" do
  describe "create" do
    it "should create a new one and go to the setting page", js: true do
      set_host "lvh.me:1337"
      billy = create(:billy)
      visit new_user_session_url(subdomain: "secure")
      #page.driver.render('screenshots/step1.png', full: true)
      fill_in "user_email", with: billy.email
      fill_in "user_password", with: "Password"
      #page.driver.render('screenshots/step2.png', full: true)
      click_button("Login")
      #page.driver.render('screenshots/step3.png', full: true)
      current_url.should eq root_url
    end
  end

end
