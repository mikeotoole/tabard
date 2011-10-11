require 'spec_helper'

describe Subdomains::PermissionsController do
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:role) { create(:role, :community => community) }
  let(:permission) { create(:permission, :role => role) }
  let(:permission_att) { attributes_for(:permission, :role_id => role.id, :permission_level => 'Create') }
  
  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end
  
  describe "GET 'index'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'index', :role_id => role.id
      response.response_code.should == 403
    end

    it "should be successful when authenticated as a community admin" do
      sign_in admin_user
      get 'index', :role_id => role.id
      response.should be_success
    end
    it "should render permissions/index template when authenticated as a community admin" do
      sign_in admin_user
      get 'index', :role_id => role.id
      response.should render_template('permissions/index')
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get 'index', :role_id => role.id
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'show'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'show', :id => permission, :role_id => role.id
      response.response_code.should == 403
    end
    
    it "should be successful when authenticated as a community admin" do
      sign_in admin_user
      get 'show', :id => permission, :role_id => role.id
      response.should be_success
    end
    it "should render permissions/show template when authenticated as a community admin" do
      sign_in admin_user
      get 'show', :id => permission, :role_id => role.id
      response.should render_template('permissions/show')
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get 'show', :id => permission, :role_id => role.id
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'new'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'new', :role_id => role.id
      response.response_code.should == 403
    end
    
    it "should be successful when authenticated as a community admin" do
      sign_in admin_user
      get 'new', :role_id => role.id
      response.should be_success
    end
    it "should render permissions/new template when authenticated as a community admin" do
      sign_in admin_user
      get 'new', :role_id => role.id
      response.should render_template('permissions/new')
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get 'new', :role_id => role.id
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET 'edit'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'edit', :id => permission, :role_id => role.id
      response.response_code.should == 403
    end

    it "should be sucess when authenticated as the community admin user" do
      sign_in admin_user
      get 'edit', :id => permission, :role_id => role.id
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => permission, :role_id => role.id
      response.should redirect_to(new_user_session_path)
    end

    it "should render permissions/edit template" do
      sign_in admin_user
      get 'edit', :id => permission, :role_id => role.id
      response.should render_template('permissions/edit')
    end
  end

  describe "POST 'create' authenticated as community admin" do
    before(:each) do
      sign_in admin_user
      post 'create', :permission => permission_att, :role_id => role.id
    end

    it "should be created" do
      Permission.exists?(permission_att).should be_true
    end

    it "should pass params to permission" do
      assigns[:permission].permission_level.should == 'Create'
    end

    it "should redirect to new permission" do
      response.should redirect_to(role_permission_path(role,assigns[:permission]))
    end
  end
  
  describe "POST 'create' authenticated as a nonadmin user" do
    before(:each) do
      sign_in user
      post 'create', :permission => permission_att, :role_id => role.id
    end
    it "should not create new record" do
      Permission.exists?(permission_att).should_not be_true
    end
    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create', :permission => permission_att, :role_id => role.id
    end
    it "should not create new record" do
      Permission.exists?(permission_att).should_not be_true
    end
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "PUT 'update' when authenticated as a community admin" do
    before(:each) do
      @permission_level = 'Update'
      sign_in admin_user
      put 'update', :id => permission, :permission => { :permission_level => @permission_level }, :role_id => role.id
    end

    it "should change attributes" do
      assigns[:permission].permission_level.should eq(@permission_level)
    end

    it "should redirect to role" do
      response.should redirect_to(role_permission_path(role,assigns[:permission]))
    end
  end

  describe "PUT 'update' when authenticated as a nonadmin user" do
    before(:each) do
      @permission_level = 'Update'
      sign_in user
      put 'update', :id => permission, :permission => { :permission_level => @permission_level }, :role_id => role.id
    end

    it "should not change attributes" do
      Permission.find(permission).permission_level.should_not eq(@permission_level)
    end

    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @permission_level = 'Update'
      put 'update', :id => permission, :permission => { :permission_level => @permission_level }, :role_id => role.id
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end

    it "should not change attributes" do
      assigns[:permission].should be_nil
    end
  end

  describe "DELETE 'destroy'" do 
    before(:each) do
      @permission = create(:permission, :role => role)
    end
    it "should be successful when authenticated as a community admin" do
      sign_in admin_user
      delete 'destroy', :id => @permission, :role_id => role.id
      response.should redirect_to(role_permissions_path(role))
      Permission.exists?(@permission).should be_false
    end
    it "should be unauthorized when authenticated as a nonadmin user" do
      sign_in user
      delete 'destroy', :id => @permission, :role_id => role.id
      Permission.exists?(@permission).should be_true
      response.response_code.should == 403
    end
    it "should not be successful when not authenticated as a user" do
      delete 'destroy', :id => @permission, :role_id => role.id
      Permission.exists?(@permission).should be_true
      response.should redirect_to(new_user_session_path)
    end
  end
end
