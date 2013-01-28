require 'spec_helper'

describe "Search" do
  describe "searching for a character should work" do
    it "it should return billy", js: true do
      set_host "lvh.me:1337"
      billy = create(:billy)
      visit search_url
      page.driver.render('screenshots/step1.png', full: true)
      fill_in "search", with: "Robo"
      page.driver.render('screenshots/step2.png', full: true)
      click_button("Search")
      page.driver.render('screenshots/step3.png', full: true)
      page.should have_content("Robobilly")
    end
  end

end
