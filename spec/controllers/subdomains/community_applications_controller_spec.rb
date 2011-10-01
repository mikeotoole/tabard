require 'spec_helper'

describe Subdomains::CommunityApplicationsController do
  let(:community_application) { create(:community_application) }
  let(:community) { community_application.community }
  let(:applicant_profile) { community_application.user_profile }
  let(:applicant_user) { applicant_profile.user }
  let(:generic_user) { create(:billy)}
  let(:additional_community_user_profile) { DefaultObjects.additional_community_user_profile }
  let(:additional_community_user) { additional_community_user_profile.user }
  let(:community_admin_profile) { community.admin_profile }
  let(:community_admin_user) { community_admin_profile.user }
  let(:community_application_attr) {{
    :submission_attributes => {:custom_form_id => DefaultObjects.community.community_application_form.id, 
    :user_profile_id => DefaultObjects.fresh_user_profile.id},
    :character_proxy_ids => [DefaultObjects.fresh_user_profile.character_proxies.first.id]
    }
  }
  
  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end
  
  describe "GET 'index'" do
    it "should be unauthorized when authenticated as application owner" do
      sign_in applicant_user
      applicant_user
      get 'index'
      response.response_code.should == 403
    end

    it "should be successful when authenticated as a community admin" do
      sign_in community_admin_user
      get 'index'
      response.should be_success
    end
    
    it "should render community_applications/index template when authenticated as a community admin" do
      sign_in community_admin_user
      get 'index'
      response.should render_template('community_applications/index')
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get 'index'
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'show'" do
    it "should be successful when authenticated as the application owner" do
      sign_in applicant_user
      get 'show', :id => community_application
      response.should be_success
    end
    
    it "should be successful when authenticated as a community admin" do
      sign_in community_admin_user
      get 'show', :id => community_application
      response.should be_success
    end

    it "should be unauthorized when authenticated as a generic member" do
      sign_in generic_user
      get 'show', :id => community_application
      response.response_code.should == 403
    end
    
    it "should render community_applications/show template when authenticated as a community admin" do
      sign_in applicant_user
      get 'show', :id => community_application
      response.should render_template('community_applications/show')
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get 'show', :id => community_application
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'new'" do
    it "should be successful when authenticated as the application owner" do
      sign_in applicant_user
      get 'new'
      response.should be_success
    end
    
    it "should be successful when authenticated as the community admin" do
      sign_in community_admin_user
      get 'new'
      response.should be_success
    end
    
    it "should render community_applications/new template when authenticated as a community admin" do
      sign_in applicant_user
      get 'new'
      response.should render_template('community_applications/new')
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get 'new'
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'edit'" do
    it "should be successful when authenticated as the application owner" do
      sign_in applicant_user
      get 'edit', :id => community_application
      response.should be_success
    end
    
    it "should be unauthorized when authenticated as the community admin" do
      sign_in community_admin_user
      get 'edit', :id => community_application
      response.response_code.should == 403
    end
    
    it "should render community_applications/new template when authenticated as a community admin" do
      sign_in applicant_user
      get 'edit', :id => community_application
      response.should render_template('community_applications/edit')
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get 'edit', :id => community_application
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "POST 'create' authenticated as owner" do
    before(:each) do
      sign_in applicant_user
      post 'create', :community_application => community_application_attr
    end

    it "should create community application" do
      CommunityApplication.exists?(assigns[:community_application]).should be_true
    end

    it "should pass params to community application" do
      assigns[:community_application].user_profile.should eq(applicant_user.user_profile)
    end

    it "should redirect to new community application" do
      response.should redirect_to(community_application_path(assigns[:community_application]))
    end
  end
  
  describe "POST 'create' authenticated as a current member" do
    before(:each) do
      sign_in additional_community_user
      post 'create'
    end

    it "should render edit to new community application" do
      #response.should render_template('community_applications/new')
    end
  end

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create', :community_application => community_application_attr
    end
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "PUT 'update' when authenticated as owner" do
    before(:each) do
      @application_id = community_application.id
      @old_character = community_application.character_proxies.first
      sign_in applicant_user
      put 'update', :id => community_application, :community_application => { :character_proxy_ids => [] }
    end

    it "should change attributes" do
      CommunityApplication.find_by_id(@application_id).character_proxy_ids.include?(@old_character.id).should be_false
    end

    it "should redirect to role" do
      response.should redirect_to(community_application_path(community_application))
    end
  end

  describe "PUT 'update' when authenticated as community admin" do
    before(:each) do
      @application_id = community_application.id
      @old_character = community_application.character_proxies.first
      sign_in community_admin_user
      put 'update', :id => community_application, :community_application => { :character_proxy_ids => [] }
    end

    it "should not change attributes" do
      CommunityApplication.find_by_id(@application_id).character_proxy_ids.include?(@old_character.id).should be_true
    end

    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @new_name = 'New Name'
      put 'update', :id => community_application
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end

    it "should not change attributes" do
      assigns[:community_applicaiton].should be_nil
    end
  end

  describe "DELETE 'destroy'" do 
    before(:each) do
      @community_application = community_application
    end
    
    it "should be  when authenticated as application owner" do
      sign_in applicant_user
      delete 'destroy', :id => @community_application
      response.should redirect_to(community_application_path)
      CommunityApplication.find(@community_application).withdrawn?.should be_true
    end
    
    it "should be unauthorized when authenticated as a community admin" do
      sign_in community_admin_user
      delete 'destroy', :id => @community_application
      response.response_code.should == 403
      CommunityApplication.exists?(@community_application).should be_true
    end
    
    it "should not be successful when not authenticated as a user" do
      delete 'destroy', :id => @community_application
      CommunityApplication.exists?(@community_application).should be_true
      response.should redirect_to(new_user_session_path)
    end
  end
end