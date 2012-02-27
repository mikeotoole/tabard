require 'spec_helper'

describe "ActiveAdmin ArtworkUploader" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:artwork_upload) { create(:artwork_upload) }
 
  describe "#index" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_artwork_uploads_url
      page.status_code.should == 200
      current_url.should == admin_artwork_uploads_url
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_artwork_uploads_url
      page.status_code.should == 200
      current_url.should == admin_artwork_uploads_url
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_artwork_uploads_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_artwork_uploads_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_artwork_uploads_url
      current_path.should == new_admin_user_session_path
    end    
  end 

  describe "#show" do 
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit admin_artwork_upload_url(:id => artwork_upload.id)
      page.status_code.should == 200
      current_url.should == admin_artwork_upload_url(:id => artwork_upload.id)
    end 
    
    it "returns 200 when logged in as admin" do
      login_as admin

      visit admin_artwork_upload_url(:id => artwork_upload.id)
      page.status_code.should == 200
      current_url.should == admin_artwork_upload_url(:id => artwork_upload.id)
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit admin_artwork_upload_url(:id => artwork_upload.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      visit admin_artwork_upload_url(:id => artwork_upload.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "redirects to login page when not logged in" do
      visit admin_artwork_upload_url(:id => artwork_upload.id)
      current_path.should == new_admin_user_session_path
    end    
  end

  describe "#new" do 
    it "raises error ActionNotFound" do
      lambda { visit new_admin_artwork_upload_url }.should raise_error(AbstractController::ActionNotFound)
    end    
  end
  
  describe "#edit" do 
    it "raises error ActionNotFound" do
      lambda { visit edit_admin_artwork_upload_url(:id => artwork_upload.id) }.should raise_error(AbstractController::ActionNotFound)
    end    
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/admin/artwork_uploads") }.should raise_error(AbstractController::ActionNotFound)
    end
  end
  
  describe "#update" do
    it "raises error ActionNotFound" do
      lambda { page.driver.put("/admin/artwork_uploads/#{artwork_upload.id}", { :artwork_upload => { :email => "test_case_name" } } ) }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#destroy" do
    it "deletes artwork_upload when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/admin/artwork_uploads/#{artwork_upload.id}")
      ArtworkUpload.exists?(artwork_upload).should be_false
    end 
    
    it "deletes artwork_upload when logged in as admin" do
      login_as admin

      page.driver.delete("/admin/artwork_uploads/#{artwork_upload.id}")
      ArtworkUpload.exists?(artwork_upload).should be_false
    end    
    
    it "returns 403 when logged in as moderator" do
      login_as moderator

      page.driver.delete("/admin/artwork_uploads/#{artwork_upload.id}")
      ArtworkUpload.exists?(artwork_upload).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end    
    
    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/admin/artwork_uploads/#{artwork_upload.id}")
      ArtworkUpload.exists?(artwork_upload).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end
    
    it "does not delete page_space when not logged in" do
      page.driver.delete("/admin/artwork_uploads/#{artwork_upload.id}")
      ArtworkUpload.exists?(artwork_upload).should be_true
    end      
  end

end