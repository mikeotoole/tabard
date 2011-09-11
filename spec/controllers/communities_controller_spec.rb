require 'spec_helper'

describe CommunitiesController do
  let(:user) { create(:user) }
  let(:community_att) { attributes_for(:community, :name => "TestName")}
  let(:community) { create(:community)}

  describe "GET 'index'" do
    it "should be successful when authenticated as a user" do
      sign_in user
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
  
    it "should redirect to community subdomain home when not authenticated as a user" do
      get 'show', :id => community
      response.should redirect_to(subdomain_home_url(:subdomain => community.subdomain))
    end
  end
  
  describe "GET 'new'" do
    it "should be successful when authenticated as a user" do
      sign_in user
      get 'new'
      response.should be_success
    end
  
    it "shouldn't be successful when not authenticated as a user" do
      get 'new'
      response.should redirect_to(new_user_session_path)
    end
    
    it "should render communities/new template" do
      sign_in user
      get 'new'
      response.should render_template('communities/new')
    end
  end
  
  describe "GET 'edit'" do
    it "should be successful when authenticated as a user" do
      sign_in user
      get 'edit', :id => community
      assert_response :success
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => community
      response.should redirect_to(new_user_session_path)
    end
    
    it "should render communities/edit template" do
      sign_in user
      get 'edit', :id => community
      response.should render_template('communities/edit')
    end
  end
  
  describe "POST 'create' authenticated as a user" do
    before(:each) do
      sign_in user
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

  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @new_slogan = 'My new slogan.'
      sign_in user
      put 'update', :id => community, :community => { :slogan => @new_slogan }
    end
  
    it "should change attributes" do
      assigns[:community].slogan.should == @new_slogan
    end
    
    it "should redirect to new community" do
      response.should redirect_to(community_path(assigns[:community]))
    end
  end  
  
  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      put 'update', :id => community, :community => { :slogan => "New Slogan" }
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end  
    
    it "should not change attributes" do
      assigns[:community].should be_nil
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
#       response.code.should == "404"
#       response.should redirect_to("/404")
    end
 
    it "should throw routing error when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        delete 'destroy', :id => community
        assert_response :missing
      end
#       response.code.should == "404"
#       response.should redirect_to("/404")
    end
  end
end
