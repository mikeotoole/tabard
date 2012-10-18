require 'spec_helper'

describe Subdomains::RolesController do
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:pro_community) {create(:pro_community)}
  let(:pro_admin_user) {pro_community.admin_profile.user}
  let(:role) { create(:role, :community => community) }
  let(:role_att) { attributes_for(:role, :name => "TestName", :community_id => community.id) }

  before(:each) do
    @request.host = "#{community.subdomain}.lvh.me"
  end

  describe "GET 'index'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'index'
      response.response_code.should == 403
    end

    it "should be successful when authenticated as a community admin" do
      sign_in admin_user
      get 'index'
      response.should be_success
    end

    it "should render roles/index template when authenticated as a community admin" do
      sign_in admin_user
      get 'index'
      response.should render_template('roles/index')
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get 'index'
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "GET 'show'" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get 'show', :id => role
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        get 'show', :id => role
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get 'show', :id => role
        assert_response :missing
      end
    end
  end

  describe "GET 'new'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'new'
      response.response_code.should == 403
    end

    it "should be unauthorized when authenticated as a free community admin" do
      sign_in admin_user
      get 'new'
      response.response_code.should == 403
    end

    it "should be successful when authenticated as a pro community admin" do
      sign_in pro_admin_user
      get 'new'
      response.should be_success
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get 'new'
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "GET 'edit'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'edit', :id => role
      response.response_code.should == 403
    end

    it "should be sucess when authenticated as the community admin user" do
      sign_in admin_user
      get 'edit', :id => role
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => role
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "POST 'create' authenticated as pro community admin" do
    before(:each) do
      sign_in pro_admin_user
      post 'create', :role => role_att
    end

    it "should create role" do
      Role.exists?(role_att).should be_true
    end

    it "should pass params to role" do
      assigns[:role].name.should == 'TestName'
    end

    it "should redirect to new role" do
      response.should redirect_to(roles_url(subdomain: community.subdomain))
    end
  end

  describe "POST 'create' authenticated as a free community admin" do
    before(:each) do
      sign_in admin_user
      post 'create', :role => role_att
    end
    it "should not create new record" do
      Role.exists?(role_att).should_not be_true
    end
    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "POST 'create' authenticated as a nonadmin user" do
    before(:each) do
      sign_in user
      post 'create', :role => role_att
    end
    it "should not create new record" do
      Role.exists?(role_att).should_not be_true
    end
    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create', :role => role_att
    end
    it "should not create new record" do
      Role.exists?(role_att).should_not be_true
    end
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "PUT 'update' when authenticated as a community admin" do
    before(:each) do
      @new_name = 'New Name'
      sign_in admin_user
      put 'update', :id => role, :role => { :name => @new_name }
    end

    it "should change attributes" do
      assigns[:role].name.should  eq(@new_name)
    end

    it "should redirect to role" do
      response.should redirect_to(roles_url(subdomain: community.subdomain))
    end
  end

  describe "PUT 'update' when authenticated as a nonadmin user" do
    before(:each) do
      @new_name = 'New Name'
      sign_in user
      put 'update', :id => role, :role => { :name => @new_name }
    end

    it "should not change attributes" do
      assigns[:role].name.should_not eq(@new_slogan)
    end

    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @new_name = 'New Name'
      put 'update', :id => role, :role => { :name => @new_name }
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should not change attributes" do
      assigns[:role].should be_nil
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @role = create(:role, :community => community)
    end

    it "should be successful when authenticated as a pro community admin" do
      sign_in pro_admin_user
      delete 'destroy', :id => @role
      response.should redirect_to(roles_url(subdomain: community.subdomain))
      Role.exists?(@role).should be_false
    end

    it "should be unauthorized when authenticated as a free community admin" do
      sign_in admin_user
      delete 'destroy', :id => @role
      Role.exists?(@role).should be_true
      response.response_code.should == 403
    end

    it "should be unauthorized when authenticated as a nonadmin user" do
      sign_in user
      delete 'destroy', :id => @role
      Role.exists?(@role).should be_true
      response.response_code.should == 403
    end

    it "should not be successful when not authenticated as a user" do
      delete 'destroy', :id => @role
      Role.exists?(@role).should be_true
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end
end
