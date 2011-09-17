require 'spec_helper'

describe UserProfilesController do
  let(:non_owner) { create(:billy) }
  let(:user_profile) { create(:user_profile) }
  let(:private_user_profile) { create(:user_profile, :publicly_viewable => false) }
  let(:owner) { create(:user, :user_profile => user_profile) }
  let(:private_owner) { create(:user, :user_profile => private_user_profile) }
	describe "GET 'index'" do
		it "should throw routing error when authenticated as a user" do
      sign_in owner
      assert_raises(ActionController::RoutingError) do
        get 'index'
        assert_response :missing
      end
    end
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        get 'index'
        assert_response :missing
      end
    end
	end
  describe "GET 'show'" do
    describe "user_profile is publicly viewable" do
      it "show should be successful when authenticated as the owner" do
        sign_in owner
        get 'show', :id => user_profile
        response.should be_success
      end

      it "show should be successful when authenticated as a non-owner" do
        sign_in non_owner
        get 'show', :id => user_profile
        response.should be_success
      end

      it "should be successful when not authenticated as a user when user_profile is publicly viewable" do
        get 'show', :id => user_profile
        response.should be_success
      end
    end
    describe "user_profile is not publicly viewable" do
      it "show should be successful when authenticated as the owner" do
        sign_in private_owner
        get 'show', :id => private_user_profile
        response.should be_success
      end

      it "show should be successful when authenticated as a non-owner" do
        sign_in non_owner
        get 'show', :id => private_user_profile
        response.should be_success
      end

      it "should be unauthorized when not authenticated as a user when user_profile is publicly viewable" do
        get 'show', :id => private_user_profile
        response.response_code.should == 403
      end
    end
  end

  describe "GET 'new'" do
    it "should throw routing error when authenticated as a user" do
      sign_in owner
      assert_raises(ActionController::RoutingError) do
        get 'index'
        assert_response :missing
      end
    end
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        get 'index'
        assert_response :missing
      end
    end
  end

  describe "GET 'edit'" do
    it "should be unauthorized when authenticated as a non-owner" do
      sign_in non_owner
      get 'edit', :id => user_profile
      response.response_code.should == 403
    end

    it "should be sucess when authenticated as the owner" do
      sign_in owner
      get 'edit', :id => user_profile
      response.should be_success
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => user_profile
      response.should redirect_to(new_user_session_path)
    end

    it "should render communities/edit template as owner" do
      sign_in owner
      get 'edit', :id => user_profile
      response.should render_template('user_profiles/edit')
    end
  end

  describe "POST 'create'" do
    it "should throw routing error when authenticated as owner" do
      sign_in owner
      assert_raises(ActionController::RoutingError) do
        post 'create'
        assert_response :missing
      end
    end
    it "should throw routing error when authenticated as non-owner" do
      sign_in non_owner
      assert_raises(ActionController::RoutingError) do
        post 'create'
        assert_response :missing
      end
    end
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        post 'create'
        assert_response :missing
      end
    end
  end

  describe "PUT 'update' when authenticated as owner" do
    before(:each) do
      @new_first_name = 'Bob'
      sign_in owner
      put 'update', :id => user_profile, :user_profile => { :first_name => @new_first_name }
    end

    it "should change attributes" do
      UserProfile.find(user_profile).first_name.should eq(@new_first_name)
    end

    it "should redirect to show" do
      response.should redirect_to(user_profile_path(assigns[:user_profile]))
    end
  end

  describe "PUT 'update' when authenticated as non-owner" do
    before(:each) do
      @new_first_name = 'Bob'
      sign_in non_owner
      put 'update', :id => user_profile, :user_profile => { :first_name => @new_first_name }
    end

    it "should not change attributes" do
      UserProfile.find(user_profile).first_name.should_not eq(@new_first_name)
      assigns[:user_profile].first_name.should_not eq(@new_first_name)
    end

    it "should be unauthorized" do
      response.response_code.should == 403
    end
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @new_first_name = 'Bob'
      put 'update', :id => user_profile, :user_profile => { :first_name => @new_first_name }
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end

    it "should not change attributes" do
      UserProfile.find(user_profile).first_name.should_not eq(@new_first_name)
      assigns[:user_profile].should be_nil
    end
  end

  describe "DELETE 'destroy'" do
    #TODO Add 404 redirect for all routing errors
    it "should throw routing error when authenticated as owner" do
      sign_in owner
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => user_profile
        assert_response :missing
      end
    end

    it "should throw routing error when authenticated as non-owner" do
      sign_in non_owner
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => user_profile
        assert_response :missing
      end
    end
#
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => user_profile
        assert_response :missing
      end
    end
  end
end