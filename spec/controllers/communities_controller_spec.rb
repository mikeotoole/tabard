require 'spec_helper'

describe CommunitiesController do
  let(:billy) { create(:billy) }
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:community_att) { attributes_for(:community, :name => "TestName", :community_plan_id => CommunityPlan.default_plan.id)}
  describe "GET 'index'" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get :index
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        get :index
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get :index
        assert_response :missing
      end
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
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should render communities/new template" do
      sign_in billy
      get 'new'
      response.should render_template('communities/new')
    end
  end

  describe "GET 'edit'" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get :edit, :id => community
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        get :edit, :id => community
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get :edit, :id => community
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
      response.should redirect_to(edit_community_settings_url(:subdomain => assigns[:community].subdomain))
    end
  end
  
  describe "POST 'create' authenticated as billy" do
    it "should create an activity" do
      sign_in billy
      
      expect {
        post 'create', :community => {:name => "New Community", :slogan => "My slogan", :community_plan_id => CommunityPlan.default_plan.id}
      }.to change(Activity, :count).by(1)
      
      activity = Activity.last
      activity.target_type.should eql "Community"
      activity.action.should eql 'created'
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
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "PUT 'update' when authenticated as a non admin user" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        put :update, :id => community
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin_user
        put :update, :id => community
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        put :update, :id => community
        assert_response :missing
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested community when authenticated as admin" do
      community
      sign_in admin_user
      expect {
        delete :destroy, :id => community.id.to_s, :user => {:current_password => admin_user.password}
      }.to change(Community, :count).by(-1)
    end

    it "redirects to the admin's user profile when authenticated as admin" do
      sign_in admin_user
      delete :destroy, :id => community.id.to_s, :user => {:current_password => admin_user.password}
      response.should redirect_to(user_profile_url(admin_user.user_profile))
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      delete :destroy, :id => community.id.to_s
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
    
    it "should respond forbidden when not a member" do
      sign_in user
      delete :destroy, :id => community.id.to_s, :user => {:current_password => user.password}
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not admin" do
      sign_in billy
      delete :destroy, :id => community.id.to_s, :user => {:current_password => billy.password}
      response.should be_forbidden
    end
  end
end
