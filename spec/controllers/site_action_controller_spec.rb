require 'spec_helper'

describe SiteActionController do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  
  describe "PUT toggle_maintenance_mode" do
    it "redirects all traffic when logged in as superadmin" do
      controller.stub!(:current_admin_user).and_return(superadmin)
      put :toggle_maintenance_mode

      visit root_url
      current_path.should == crumblin_maintenance_path
      
      put :toggle_maintenance_mode
      
      visit root_url
      current_path.should == root_path
    end
    
    it "redirects all traffic when logged in as admin" do
      controller.stub!(:current_admin_user).and_return(admin)
      put :toggle_maintenance_mode

      visit root_url
      current_path.should == crumblin_maintenance_path
      
      put :toggle_maintenance_mode
      
      visit root_url
      current_path.should == root_path
    end
    
    it "does not redirect all traffic when logged in as moderator" do
      controller.stub!(:current_admin_user).and_return(moderator)
      put :toggle_maintenance_mode

      visit root_url
      current_path.should == root_path
    end    
    
    it "does not redirect all traffic when logged in as regular User" do
      controller.stub!(:current_admin_user).and_return(user)
      put :toggle_maintenance_mode

      visit root_url
      current_path.should == root_path
    end

    it "does not redirect all traffic when not logged in" do
      put :toggle_maintenance_mode

      visit root_url
      current_path.should == root_path
    end
  end
end  
  