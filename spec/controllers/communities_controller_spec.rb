require 'spec_helper'

describe CommunitiesController do
  let(:billy) { create(:billy) }
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:community_att) { attributes_for(:community, :name => "TestName")}
  describe "GET 'index'" do
    it "should be successful when authenticated as a user" do
      sign_in user
      get 'index'
      response.should be_success
    end

    it "should be successful when authenticated as a community admin" do
      sign_in admin_user
      get 'index'
      response.should be_success
    end

    it "should be successful when not authenticated as a user" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "show should redirect to subdomain home when authenticated as a user" do
      sign_in user
      get 'show', :id => community
      response.should redirect_to(subdomain_home_url(:subdomain => community.subdomain))
    end

    it "show should redirect to subdomain home when authenticated as the community admin" do
      sign_in admin_user
      get 'show', :id => community
      response.should redirect_to(subdomain_home_url(:subdomain => community.subdomain))
    end

    it "should redirect to community subdomain home when not authenticated as a user" do
      get 'show', :id => community
      response.should redirect_to(subdomain_home_url(:subdomain => community.subdomain))
    end
  end

  describe "GET 'new'" do
    it "should be successful when authenticated as billy" do
      sign_in billy
      get 'new'
      response.should be_success
    end

    it "should be successful when authenticated as a communtiy admin" do
      sign_in admin_user
      get 'new'
      response.should be_success
    end

    it "shouldn't be successful when not authenticated as a user" do
      get 'new'
      response.should redirect_to(new_user_session_path)
    end

    it "should render communities/new template" do
      sign_in billy
      get 'new'
      response.should render_template('communities/new')
    end
  end

  describe "GET 'edit'" do
    it "should throw routing error when authenticated as a non admin user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get 'edit', :id => community
        assert_response :missing
      end
    end

    it "should throw routing error when authenticated as the community admin user" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        get 'edit', :id => community
        assert_response :missing
      end
    end

    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        get 'edit', :id => community
        assert_response :missing
      end
    end
  end

  describe "POST 'create' authenticated as billy" do
    before(:each) do
      sign_in billy
      post 'create', :community => community_att
    end

    it "should not be new record" do
      assigns[:community].should_not be_new_record
    end

    it "should pass params to community" do
      assigns[:community].name.should == 'TestName'
    end

    it "should redirect to new community" do
      response.should redirect_to(community_path(assigns[:community]))
    end
  end

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create', :community => community_att
    end

    it "should not create new record" do
      assigns[:community].should be_nil
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end

  it "PUT Update should throw routing error when authenticated as a non admin user" do
    assert_raises(ActionController::RoutingError) do
      @new_slogan = 'My new slogan.'
      sign_in billy
      put 'update', :id => community, :community => { :slogan => @new_slogan }
      assert_response :missing
    end
  end

  it "PUT Update should throw routing error when authenticated as an admin user" do
    assert_raises(ActionController::RoutingError) do
      @new_slogan = 'My new slogan.'
      sign_in admin_user
      put 'update', :id => community, :community => { :slogan => @new_slogan }
      assert_response :missing
    end
  end

  it "PUT Update should throw routing error when not authenticated as a user" do
    assert_raises(ActionController::RoutingError) do
      put 'update', :id => community, :community => { :slogan => "New Slogan" }
      assert_response :missing
    end
  end

  describe "DELETE 'destroy'" do
    #TODO Add 404 redirect for all routing errors
    it "should throw routing error when authenticated as a user" do
      sign_in user
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => community
        assert_response :missing
      end
    end
#
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => community
        assert_response :missing
      end
    end
  end
end
