require 'spec_helper'

describe Subdomains::CommunitiesController do
  let(:billy) { create(:billy) }
  let(:user_profile) { create(:user_profile)}
  let(:user) { user_profile.user }
  let(:admin_user) { create(:community_admin) }
  let(:community) { admin_user.user_profile.owned_communities.first }
  let(:community_att) { attributes_for(:community, :name => "TestName")}

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET 'index'" do
    it "should throw routing error" do
      assert_raises(ActionController::RoutingError) do
        get 'index'
        assert_response :missing
      end
    end
  end

  describe "GET 'show'" do
    it "should throw routing error" do
      assert_raises(ActionController::RoutingError) do
        get 'show', :id => community
        assert_response :missing
      end
    end
  end

  describe "GET 'new'" do
    it "should throw routing error" do
      assert_raises(ActionController::RoutingError) do
        get 'new'
        assert_response :missing
      end
    end
  end

  describe "GET 'edit'" do
    it "should be unauthorized when authenticated as a non admin user" do
      sign_in user
      get 'edit', :id => community
      response.response_code.should == 403
    end

    it "should be sucess when authenticated as the community admin user" do
      sign_in admin_user
      get 'edit', :id => community
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => community
      response.should redirect_to(new_user_session_path)
    end

    it "should render communities/edit template" do
      sign_in admin_user
      get 'edit', :id => community
      response.should render_template('communities/edit')
    end
  end

  describe "POST 'create'" do
    it "should throw routing error" do
      assert_raises(ActionController::RoutingError) do
        post 'create', :community => community_att
        assert_response :missing
      end
    end
  end

  describe "PUT 'update' when authenticated as a non admin user" do
    before(:each) do
      @new_slogan = 'My new slogan.'
      sign_in billy
      put 'update', :id => community, :community => { :slogan => @new_slogan }
    end

    it "should change attributes" do
      assigns[:community].slogan.should_not == @new_slogan
    end

    it "should respond with an error" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when authenticated as an admin user" do
    before(:each) do
      @new_slogan = 'My new slogan.'
      sign_in admin_user
      put 'update', :id => community, :community => { :slogan => @new_slogan }
    end

    it "should change attributes" do
      assigns[:community].slogan.should == @new_slogan
    end

    it "should redirect to the community edit view" do
      response.should redirect_to(edit_community_url(assigns[:community]))
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @slogan = "New Slogan"
      put 'update', :id => community, :community => { :slogan => @slogan }
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end

    it "should not change attributes" do
      assigns[:community].slogan.should_not eq @slogan
    end
  end

  describe "DELETE 'destroy'" do
    #TODO Joe, Add 404 redirect for all routing errors.
    it "should throw routing error when authenticated as a user" do
      sign_in user
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => community
        assert_response :missing
      end
#       delete 'destroy'
#       response.code.should == "404"
#       response.should redirect_to("/404")
    end
#
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => community
        assert_response :missing
      end
#       delete 'destroy'
#       response.code.should == "404"
#       response.should redirect_to("/404")
    end
  end
end
