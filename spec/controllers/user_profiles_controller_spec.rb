require 'spec_helper'

describe UserProfilesController do
  let(:non_owner) { create(:billy) }
  let(:owner) { create(:user) }
  let(:user_profile) { owner.user_profile }
  let(:disabled_user_profile) { create(:disabled_user).user_profile }

	describe "GET 'dashboard'" do
		it "should show the current user when authenticated as a user" do
      sign_in owner
      get 'dashboard'
      assigns[:user_profile].should eq(owner.user_profile)
      response.should be_success
      response.should render_template('user_profiles/show')
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get 'dashboard'
      response.should redirect_to(new_user_session_url)
    end
	end

  describe "GET 'account'" do
    it "should show the current user when authenticated as a user" do
      sign_in owner
      get 'account'
      assigns[:user_profile].should eq(owner.user_profile)
      response.should be_success
      response.should render_template('user_profiles/edit')
    end
    it "should redirected to new user session path when not authenticated as a user" do
      get 'account'
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET 'show'" do
    describe "when user_profile is not disabled" do
      it "should be successful when authenticated as the owner" do
        sign_in owner
        get 'show', :id => user_profile
        response.should be_success
        response.should render_template('user_profiles/show')
      end

      it "should be successful when authenticated as a non-owner" do
        sign_in non_owner
        get 'show', :id => user_profile
        response.should be_success
      end

      it "should be successful when not authenticated as a user" do
        get 'show', :id => user_profile
        response.should be_success
      end
    end

    describe "when user_profile is disabled" do
      it "show should be successful when authenticated as a non-owner" do
        sign_in non_owner
        get 'show', :id => disabled_user_profile
        response.should redirect_to(root_path)
      end

      it "show should be successful when not authenticated as a user" do
        get 'show', :id => disabled_user_profile
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET 'new'" do
    it "should throw routing error when authenticated as a user" do
      sign_in owner
      assert_raises(ActionController::RoutingError) do
        get 'new'
        assert_response :missing
      end
    end
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        get 'new'
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
      response.should redirect_to(new_user_session_url)
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
      response.should redirect_to(user_profile_url(assigns[:user_profile]))
    end
    
    it "should create an Activity when attributes change" do
      activity = Activity.last
      activity.target.should eql user_profile
      activity.action.should eql 'profile'
    end
  end
  
  describe "PUT 'update' when authenticated as owner" do
    it "should not create an Activity when attributes don't change" do
      sign_in owner
      
      expect {
        put 'update', :id => user_profile, :user_profile => nil
      }.to change(Activity, :count).by(0)
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
      response.should redirect_to(new_user_session_url)
    end

    it "should not change attributes" do
      UserProfile.find(user_profile).first_name.should_not eq(@new_first_name)
      assigns[:user_profile].should be_nil
    end
  end

  describe "DELETE 'destroy'" do
    #TODO Joe, Add 404 redirect for all routing errors.
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