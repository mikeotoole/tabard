require 'spec_helper'

describe Subdomains::AnnouncementSpacesController do
  let(:member) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }
  let(:space) { DefaultObjects.announcement_discussion_space }
  
  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET index" do
    it "assigns all announcement_spaces as @announcement_spaces when authenticated as a member" do
      space
      sign_in member
      get :index
      assigns(:announcement_spaces).should eq(community.announcement_spaces)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :index
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :index
      response.should be_forbidden
    end
  end

  describe "GET show" do
    it "assigns the requested announcement_space as @announcement_space when authenticated as a member" do
      sign_in member
      get :show, :id => space
      assigns(:announcement_space).should eq(space)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :show, :id => space
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :show, :id => space
      response.should be_forbidden
    end    
  end
end
