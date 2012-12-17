require 'spec_helper'

describe "ActiveAdmin PageSpace" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:page_space) { DefaultObjects.page_space }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_page_spaces_url
      page.status_code.should == 200
      current_url.should == alexandria_page_spaces_url
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_page_spaces_url
      page.status_code.should == 200
      current_url.should == alexandria_page_spaces_url
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_page_spaces_url
      page.status_code.should == 200
      current_url.should == alexandria_page_spaces_url
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_page_spaces_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_page_spaces_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == alexandria_page_space_url(:id => page_space.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == alexandria_page_space_url(:id => page_space.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == alexandria_page_space_url(:id => page_space.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_page_space_url(:id => page_space.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#new" do
    it "raises error ActionNotFound" do
      lambda { visit new_alexandria_page_space_url }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#edit" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_page_space_url(:id => page_space.id)
    end

    it "returns 200 when logged in as admin" do
      login_as admin

      visit edit_alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_page_space_url(:id => page_space.id)
    end

    it "returns 200 when logged in as moderator" do
      login_as moderator

      visit edit_alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_page_space_url(:id => page_space.id)
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_alexandria_page_space_url(:id => page_space.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit edit_alexandria_page_space_url(:id => page_space.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#create" do
    it "raises error ActionNotFound" do
      lambda { page.driver.post("/alexandria/page_spaces") }.should raise_error(AbstractController::ActionNotFound)
    end
  end

  describe "#update" do
    it "updates page_space when logged in as superadmin" do
      login_as superadmin
      page.driver.put("/alexandria/page_spaces/#{page_space.id}", { :page_space => { :name => "test_case_name" } } )
      PageSpace.find(page_space).name.should eql "test_case_name"
    end

    it "updates page_space when logged in as admin" do
      login_as admin
      page.driver.put("/alexandria/page_spaces/#{page_space.id}", { :page_space => { :name => "test_case_name" } } )
      PageSpace.find(page_space).name.should eql "test_case_name"
    end

    it "updates page_space when logged in as moderator" do
      login_as moderator
      page.driver.put("/alexandria/page_spaces/#{page_space.id}", { :page_space => { :name => "test_case_name" } } )
      PageSpace.find(page_space).name.should eql "test_case_name"
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      original_name = page_space.name
      page.driver.put("/alexandria/page_spaces/#{page_space.id}", { :page_space => { :name => "test_case_name" } } )
      PageSpace.find(page_space).name.should eql original_name
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not update page_space when not logged in" do
      original_name = page_space.name
      page.driver.put("/alexandria/page_spaces/#{page_space.id}", { :page_space => { :name => "test_case_name" } } )
      PageSpace.find(page_space).name.should eql original_name
    end
  end

  describe "#destroy" do
    it "deletes page_space when logged in as superadmin" do
      login_as superadmin

      page.driver.delete("/alexandria/page_spaces/#{page_space.id}")
      PageSpace.exists?(page_space).should be_false
    end

    it "deletes page_space when logged in as admin" do
      login_as admin

      page.driver.delete("/alexandria/page_spaces/#{page_space.id}")
      PageSpace.exists?(page_space).should be_false
    end

    it "deletes page_space when logged in as moderator" do
      login_as moderator

      page.driver.delete("/alexandria/page_spaces/#{page_space.id}")
      PageSpace.exists?(page_space).should be_false
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      page.driver.delete("/alexandria/page_spaces/#{page_space.id}")
      PageSpace.exists?(page_space).should be_true
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not delete page_space when not logged in" do
      page.driver.delete("/alexandria/page_spaces/#{page_space.id}")
      PageSpace.exists?(page_space).should be_true
    end
  end

end