require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe Subdomains::DiscussionsController do
  let(:owner) { DefaultObjects.user }
  let(:non_owner) { 
    profile = create(:user_profile)
    DefaultObjects.community.promote_user_profile_to_member(profile)
    profile.user
  }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }
  let(:discussion) { DefaultObjects.discussion }
  let(:space) { DefaultObjects.discussion_space }
  let(:anouncment_space) { DefaultObjects.announcement_discussion_space }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET index" do
    it "assigns all discussions as @discussions when authenticated as a member" do
      discussion
      sign_in owner
      get :index, :discussion_space_id => space.id
      assigns(:discussions).should eq([discussion])
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :index, :discussion_space_id => space.id
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :index, :discussion_space_id => space.id
      response.should be_forbidden
    end    
  end

  describe "GET show" do
    it "assigns the requested discussion as @discussion when authenticated as a member" do
      sign_in owner
      get :show, :id => discussion.id.to_s
      assigns(:discussion).should eq(discussion)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :show, :id => discussion.id.to_s
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :show, :id => discussion.id.to_s
      response.should be_forbidden
    end   
  end

  describe "GET new" do
    it "assigns a new discussion as @discussion when authenticated as a member" do
      sign_in owner
      get :new, :discussion_space_id => space.id
      assigns(:discussion).should be_a_new(Discussion)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :new, :discussion_space_id => space.id
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :new, :discussion_space_id => space.id
      response.should be_forbidden
    end
    
    it "should respond forbidden when discussion space is announcements space and user is member" do
      sign_in owner
      get :new, :discussion_space_id => anouncment_space.id
      response.should be_forbidden
    end
    
    it "assigns a new discussion as @discussion when discussion space is announcements space and user is community admin" do
      sign_in admin
      get :new, :discussion_space_id => anouncment_space.id
      assigns(:discussion).should be_a_new(Discussion)
    end
  end

  describe "GET edit" do
    it "assigns the requested discussion as @discussion when authenticated as a owner" do
      sign_in owner
      get :edit, :id => discussion.id.to_s
      assigns(:discussion).should eq(discussion)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :edit, :id => discussion.id.to_s
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :edit, :id => discussion.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when not owner" do
      sign_in non_owner
      get :edit, :id => discussion.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST create when authenticated as member" do
    before(:each) {
      sign_in owner
    }
  
    describe "with valid params" do
      it "creates a new Discussion" do
        space
        expect {
          post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion)
        }.to change(Discussion, :count).by(1)
      end

      it "assigns a newly created discussion as @discussion" do
        post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion)
        assigns(:discussion).should be_a(Discussion)
        assigns(:discussion).should be_persisted
      end

      it "redirects to the created discussion" do
        post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion)
        response.should redirect_to(Discussion.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved discussion as @discussion" do
        post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion, :name => nil)
        assigns(:discussion).should be_a_new(Discussion)
      end

      it "re-renders the 'new' template" do
        post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion, :name => nil)
        response.should render_template("new")
      end
    end
  end
  
  describe "POST create" do
    it "should redirect to new user session path when not authenticated as a user" do
      post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion)
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :create, :discussion_space_id => space.id, :discussion => attributes_for(:discussion)
      response.should be_forbidden
    end
    
    it "should respond forbidden when discussion space is announcements space and user is member" do
      sign_in owner
      post :create, :discussion_space_id => anouncment_space.id, :discussion => attributes_for(:discussion)
      response.should be_forbidden
    end
    
    it "creates a new Discussion when discussion space is announcements space and user is community admin" do
      sign_in admin
      anouncment_space
      expect {
        post :create, :discussion_space_id => anouncment_space.id, :discussion => attributes_for(:discussion)
      }.to change(Discussion, :count).by(1)
    end
  end

  describe "PUT update when authenticated as owner" do
    before(:each) {
      sign_in owner
    }
  
    describe "with valid params" do
      it "updates the requested discussion" do
        discussion
        # Assuming there are no other discussions in the database, this
        # specifies that the Discussion created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Discussion.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => discussion.id, :discussion => {'these' => 'params'}
      end

      it "assigns the requested discussion as @discussion" do
        put :update, :id => discussion.id, :discussion => {:name => "New name"}
        assigns(:discussion).should eq(discussion)
      end

      it "redirects to the discussion" do
        put :update, :id => discussion.id, :discussion => {:name => "New name"}
        response.should redirect_to(discussion)
      end
    end

    describe "with invalid params" do
      it "assigns the discussion as @discussion" do
        put :update, :id => discussion.id.to_s, :discussion => {:name => nil}
        assigns(:discussion).should eq(discussion)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => discussion.id.to_s, :discussion => {:name => nil}
        response.should render_template("edit")
      end
    end
  end

  describe "PUT update" do
    it "should redirect to new user session path when not authenticated as a user" do
      put :update, :id => discussion.id, :discussion => {:name => "New name"}
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      put :update, :id => discussion.id, :discussion => {:name => "New name"}
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not owner" do
      sign_in non_owner
      put :update, :id => discussion.id, :discussion => {:name => "New name"}
      response.should be_forbidden
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested discussion when authenticated as owner" do
      discussion
      sign_in owner
      expect {
        delete :destroy, :id => discussion.id.to_s
      }.to change(Discussion, :count).by(-1)
    end

    it "redirects to the discussions list when authenticated as owner" do
      sign_in owner
      delete :destroy, :id => discussion.id.to_s
      response.should redirect_to(discussion.discussion_space)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      delete :destroy, :id => discussion.id.to_s
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      delete :destroy, :id => discussion.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not owner" do
      sign_in non_owner
      delete :destroy, :id => discussion.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST lock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
    }
  
    it "should lock the discussion when authenticated as community admin" do
      sign_in admin
      post :lock, :id => discussion.id.to_s
      Discussion.find(discussion).has_been_locked.should be_true
    end
    
    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :lock, :id => discussion.id.to_s
      response.should redirect_to("/")
    end
    
    it "should not lock the discussion when authenticated as a member" do
      sign_in owner
      post :lock, :id => discussion.id.to_s
      Discussion.find(discussion).has_been_locked.should be_false    
    end
    
    it "should not lock the discussion when not authenticated as a user" do
      post :lock, :id => discussion.id.to_s
      Discussion.find(discussion).has_been_locked.should be_false 
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      post :lock, :id => discussion.id.to_s
      response.should redirect_to(new_user_session_path) 
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :lock, :id => discussion.id.to_s
      response.should be_forbidden
    end
  end
  
  describe "POST unlock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
      discussion.has_been_locked = true
      discussion.save
    }
  
    it "should unlock the discussion when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => discussion.id.to_s
      Discussion.find(discussion).has_been_locked.should be_false
    end
    
    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => discussion.id.to_s
      response.should redirect_to("/")
    end
    
    it "should not unlock the discussion when authenticated as a member" do
      sign_in owner
      post :unlock, :id => discussion.id.to_s
      Discussion.find(discussion).has_been_locked.should be_true    
    end
    
    it "should not unlock the discussion when not authenticated as a user" do
      post :unlock, :id => discussion.id.to_s
      Discussion.find(discussion).has_been_locked.should be_true 
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      post :unlock, :id => discussion.id.to_s
      response.should redirect_to(new_user_session_path) 
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :unlock, :id => discussion.id.to_s
      response.should be_forbidden
    end
  end
end
