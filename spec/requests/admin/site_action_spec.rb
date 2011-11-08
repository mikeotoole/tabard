require 'spec_helper'

describe "SiteAction" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
 
  describe "#toggle_maintenance_mode" do 
    it "redirects all traffic when logged in as superadmin" do
      login_as superadmin
      
      visit admin_dashboard_url
      current_path.should == admin_dashboard_path
      click_button "Toggle Maintenance Mode"
      
      visit root_url
      current_path.should == crumblin_maintenance_path
    end 
    
    it "redirects all traffic when logged in as admin" do
      login_as admin

      visit root_url
      current_path.should == root_path
      page.driver.put(toggle_maintenance_mode_path)
      visit root_url
      current_path.should == crumblin_maintenance_path
    end
    
    it "does not redirect all traffic when logged in as moderator" do
      login_as moderator

      visit root_url
      current_path.should == root_path
      page.driver.put(toggle_maintenance_mode_path)
      visit root_url
      current_path.should == root_path
    end    
    
    it "does not redirect all traffic when logged in as regular User" do
      login_as user

      visit root_url
      current_path.should == root_path
      page.driver.put(toggle_maintenance_mode_path)
      visit root_url
      current_path.should == root_path
    end

    it "does not redirect all traffic when not logged in" do
      visit root_url
      current_path.should == root_path
      page.driver.put(toggle_maintenance_mode_path)
      visit root_url
      current_path.should == root_path
    end
  end
end  