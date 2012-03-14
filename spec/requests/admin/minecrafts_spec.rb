require 'spec_helper'

describe "ActiveAdmin Minecraft" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }

  let(:minecraft) { DefaultObjects.minecraft }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_minecrafts_url
      page.status_code.should == 200
      current_url.should == admin_minecrafts_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_minecrafts_url
      page.status_code.should == 200
      current_url.should == admin_minecrafts_url
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_minecrafts_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_minecrafts_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit admin_minecrafts_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 200
      current_url.should == admin_minecraft_url(:id => minecraft.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 200
      current_url.should == admin_minecraft_url(:id => minecraft.id)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_minecraft_url(:id => minecraft.id)
      current_path.should == new_admin_user_session_path
    end    
  end
  
  describe "#new" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit new_admin_minecraft_url
      page.status_code.should == 200
      current_url.should == new_admin_minecraft_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit new_admin_minecraft_url
      page.status_code.should == 200
      current_url.should == new_admin_minecraft_url
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit new_admin_minecraft_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit new_admin_minecraft_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end 
    
    it "redirects to login page when not logged in" do
      visit new_admin_minecraft_url
      current_path.should == new_admin_user_session_path
    end   
  end

  describe "#edit" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 200
      current_url.should == edit_admin_minecraft_url(:id => minecraft.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 200
      current_url.should == edit_admin_minecraft_url(:id => minecraft.id)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_admin_minecraft_url(:id => minecraft.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit edit_admin_minecraft_url(:id => minecraft.id)
      current_path.should == new_admin_user_session_path
    end        
  end

  describe "#create" do
    it "creates Minecraft when logged in as superadmin" do
      login_as superadmin
      expect {
        page.driver.post("/admin/minecrafts", { :minecraft => attributes_for(:minecraft) } )
      }.to change(Minecraft, :count).by(1)
    end 
    
    it "creates Wow when logged in as admin" do
      login_as admin
      expect {
        page.driver.post("/admin/minecrafts", { :minecraft => attributes_for(:minecraft) } )
      }.to change(Minecraft, :count).by(1)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator
      expect {
        page.driver.post("/admin/minecrafts", { :minecraft => attributes_for(:minecraft) } )
      }.to change(Minecraft, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user
      expect {
        page.driver.post("/admin/minecrafts", { :minecraft => attributes_for(:minecraft) } )
      }.to change(Minecraft, :count).by(0)
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "does not create Wow when not logged in" do
      expect {
        page.driver.post("/admin/minecrafts", { :minecraft => attributes_for(:minecraft) } )
      }.to change(Minecraft, :count).by(0)
    end    
  end

  describe "#update" do 
    it "updates Minecraft when logged in as superadmin" do
      login_as superadmin
      
      page.driver.put("/admin/minecrafts/#{minecraft.id}", { :minecraft => { :server_type => "PvP" } } )
      Minecraft.find(minecraft).server_type.should eql "PvP"
    end
    
    it "updates Minecraft when logged in as admin" do
      login_as admin
      
      page.driver.put("/admin/minecrafts/#{minecraft.id}", { :minecraft => { :server_type => "PvP" } } )
      Minecraft.find(minecraft).server_type.should eql "PvP"
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      orginal_server = minecraft.server_type
      page.driver.put("/admin/minecrafts/#{minecraft.id}", { :minecraft => { :server_type => "PvP" } } )
      Minecraft.find(minecraft).server_type.should eql orginal_server
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      orginal_server = minecraft.server_type
      page.driver.put("/admin/minecrafts/#{minecraft.id}", { :minecraft => { :server_type => "PvP" } } )
      Minecraft.find(minecraft).server_type.should eql orginal_server
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "does not update Minecraft when not logged in" do
      orginal_server = minecraft.server_type
      page.driver.put("/admin/minecrafts/#{minecraft.id}", { :minecraft => { :server_type => "PvP" } } )
      Minecraft.find(minecraft).server_type.should eql orginal_server
    end   
  end
 
  describe "#destroy" do 
    it "raises error ActionNotFound" do
      lambda { page.driver.delete("/admin/minecrafts/#{minecraft.id}") }.should raise_error(AbstractController::ActionNotFound)
    end  
  end
end
