require 'spec_helper'

describe "ActiveAdmin CommunityPlan" do
  let(:superadmin) { create(:admin_user) }
  let(:admin) { create(:admin_user, :role => 'admin') }
  let(:moderator) { create(:admin_user, :role => 'moderator') }
  let(:user) { DefaultObjects.user }
  let(:community_plan) { create(:community_plan) }

  describe "#index" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_community_plans_url
      page.status_code.should == 200
      current_url.should == alexandria_community_plans_url
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit alexandria_community_plans_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit alexandria_community_plans_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_community_plans_url
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_community_plans_url
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#show" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 200
      current_url.should == alexandria_community_plan_url(:id => community_plan.id)
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit alexandria_community_plan_url(:id => community_plan.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#edit" do
    it "returns 200 when logged in as superadmin" do
      login_as superadmin

      visit edit_alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 200
      current_url.should == edit_alexandria_community_plan_url(:id => community_plan.id)
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      visit edit_alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      visit edit_alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      visit edit_alexandria_community_plan_url(:id => community_plan.id)
      page.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "redirects to login page when not logged in" do
      visit edit_alexandria_community_plan_url(:id => community_plan.id)
      current_path.should == new_admin_user_session_path
    end
  end

  describe "#update" do
    it "updates community_plan when logged in as superadmin" do
      login_as superadmin
      page.driver.put("/alexandria/community_plans/#{community_plan.id}", { :community_plan => { :title => "test_case_name" } } )
      CommunityPlan.find(community_plan).title.should eql "test_case_name"
    end

    it "returns 403 when logged in as admin" do
      login_as admin

      original_name = community_plan.title
      page.driver.put("/alexandria/community_plans/#{community_plan.id}", { :community_plan => { :title => "test_case_name" } } )
      CommunityPlan.find(community_plan).title.should eql original_name
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as moderator" do
      login_as moderator

      original_name = community_plan.title
      page.driver.put("/alexandria/community_plans/#{community_plan.id}", { :community_plan => { :title => "test_case_name" } } )
      CommunityPlan.find(community_plan).title.should eql original_name
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "returns 403 when logged in as regular User" do
      login_as user

      original_name = community_plan.title
      page.driver.put("/alexandria/community_plans/#{community_plan.id}", { :community_plan => { :title => "test_case_name" } } )
      CommunityPlan.find(community_plan).title.should eql original_name
      page.driver.status_code.should == 403
      page.should have_content('Forbidden')
    end

    it "does not update community_plan when not logged in" do
      original_name = community_plan.title
      page.driver.put("/alexandria/community_plans/#{community_plan.id}", { :community_plan => { :title => "test_case_name" } } )
      CommunityPlan.find(community_plan).title.should eql original_name
    end
  end

  describe "#destroy" do
    it "raises error ActionController::RoutingError" do
      expect { page.driver.delete("/alexandria/community_plans/#{community_plan.id}") }.to raise_error(ActionController::RoutingError)
    end
  end
end