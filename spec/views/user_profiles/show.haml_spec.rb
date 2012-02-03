require 'spec_helper'
include ViewMacros

describe "user_profiles/show.haml" do
  before(:each) do
    @activities_count_initial = 20
    @activities_count_increment = 10
    @activities = {}
  end

  describe "when user_profile is publicly viewable" do
    before(:each) do
      @user_profile = create(:user_profile, :publicly_viewable => true)
    end
  
    it "should show activities when authenticated as the owner" do
      login_user @user_profile.user
      render
      rendered.should include("Recent Activity")
    end

    it "should show activities when authenticated as a non-owner" do
      login_user
      render
      rendered.should include("Recent Activity")
    end
    
    it "should show activities when not authenticated" do
      login_user nil
      render
      rendered.should include("Recent Activity")
    end
  end

  describe "when user_profile is not publicly viewable" do
    before(:each) do
      @user_profile = create(:user_profile, :publicly_viewable => false)
    end
    
    it "should show activities when authenticated as the owner" do
      login_user @user_profile.user
      render
      rendered.should include("Recent Activity")
    end

    it "should not show activities when authenticated as a non-owner" do
      login_user
      render
      rendered.should_not include("Recent Activity")
    end
    
    it "should not show activities when not authenticated" do
      login_user nil
      render
      rendered.should_not include("Recent Activity")
    end
  end
end
