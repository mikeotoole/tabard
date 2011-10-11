require 'spec_helper'

describe ActiveProfilesController do
  let(:billy) { create(:billy) }
  let(:another_profile) { create(:user_profile_with_characters) }
  let(:another_person) { another_profile.user }

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create'
    end

    it "should not activate user_profile" do
      session[:profile_type].should be_nil
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create' when using own profile for user" do
    before(:each) do
      sign_in billy
      post 'create', :id => billy.user_profile.id, :type => billy.user_profile.class
    end

    it "should activate user_profile" do
      session[:profile_type].should eq("UserProfile")
      session[:profile_id].should eq(billy.user_profile.id.to_s)
    end

  end

  describe "POST 'create' when using anothers profile for user" do
    before(:each) do
      sign_in billy
      post 'create', :id => another_person.user_profile.id, :type => another_person.user_profile.class
    end

    it "should activate current_user user_profile" do
      session[:profile_type].should eq "UserProfile"
      session[:profile_id].should eq billy.user_profile.id
    end

    it "should redirect to root path" do
      response.should redirect_to(root_path)
    end
  end

  describe "POST 'create' when using own character for user" do
    before(:each) do
      sign_in billy
      @character = billy.user_profile.character_proxies.first.character 
      post 'create', :id => @character.id, :type => @character.class
    end

    it "should not activate user_profile" do
      session[:profile_type].should match(/Character$/)
      session[:profile_id].should eq(@character.id.to_s)
    end
  end

  describe "POST 'create' when using anothers character for user" do
    before(:each) do
      sign_in billy
      @character = another_person.user_profile.character_proxies.first.character 
      post 'create', :id => @character.id, :type => @character.class
    end

    it "should activate current_user user_profile" do
      session[:profile_type].should eq "UserProfile"
      session[:profile_id].should eq billy.user_profile.id
    end

    it "should redirect to root path" do
      response.should redirect_to(root_path)
    end
  end

end
