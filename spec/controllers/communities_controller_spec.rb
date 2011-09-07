require 'spec_helper'

describe CommunitiesController do
  let(:user) { Factory.create(:user) }
  let(:community_att) { Factory.attributes_for(:community)}
  let(:community) { Factory.create(:community)}

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
    it "should redirect to community subdomain home when not authenticated as a user" do
      get 'show', :id => community.id
      response.should redirect_to(subdomain_home_url(:subdomain => community.subdomain))
    end
  
    it "show should redirect to subdomain home when authenticated as a user" do
      sign_in user
      get 'show', :id => community.id
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
  end
  
  describe "POST 'create' authenticated as a user" do
    before(:each) do
      sign_in user
      @community = community
      post 'create'
    end
    
    it "should be successful" do
      response.should be_success
    end
    
    it "should be new record" do
      assigns[:community].should be_new_record
    end
    
    it "should redirect to community path" do
      #TODO Mike, What is the syntax for this?
#       response.should redirect_to(community_path(@community))
    end
  end
  
  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      @community = community
      post 'create'
    end
    
    it "shouldn't be successful" do
      response.should_not be_success
    end
    
    it "should not create new record" do
      assigns[:community].should == nil
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end   
  
  describe "GET 'edit' when authenticated as a user" do
    before(:each) do
      sign_in user
      get 'edit', :id => community.id
    end
  
    it "should be successful" do
      assert_response :success
    end
  end
  
  describe "GET 'edit' when not authenticated as a user" do
    before(:each) do
      get 'edit', :id => community.id
    end
  
    it "shouldn't be successful" do
      response.should_not be_success
    end
    
    it "should redirected to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "PUT 'update'" do
    it "should be successful when authenticated as a user" do
      sign_in user
      put 'update', :id => community.id, :community => community_att
      response.should be_success
#       assert_redirected_to community_path(assigns(:community))
    end
  
    it "should redirect to new user session path when not authenticated as a user" do
      put 'update', :id => community.id, :community => community_att
      response.should redirect_to(new_user_session_path)
    end
  end    

  describe "DELETE 'destroy'" do
    #TODO Add 404 redirect for all routing errors
#     it "should redirect to 404 when authenticated as a user" do
#       sign_in user
#       @community = community
#       delete 'destroy'
#       response.should redirect_to("/404")
#     end
# 
#     it "should redirect to 404 when not authenticated as a user" do
#       @community = community
#       delete 'destroy'
#       response.should redirect_to("/404")
#       end
#     end
  end
end
