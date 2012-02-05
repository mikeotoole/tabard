require 'spec_helper'

describe Subdomains::AnnouncementsController do
  let(:member) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }
  let(:announcement) { create(:announcement, :community => community, :user_profile => admin.user_profile) }
  let(:announcement_attr) { attributes_for(:announcement, :community => community, :user_profile => admin.user_profile) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET show" do
    it "assigns the requested announcement as @announcement when authenticated as a member" do
      sign_in member
      get :show, :id => announcement.id.to_s
      assigns(:announcement).should eq(announcement)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :show, :id => announcement.id.to_s
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :show, :id => announcement.id.to_s
      response.should be_forbidden
    end   
  end

  describe "GET new" do
    it "assigns a new announcement as @announcement when authenticated as a admin" do
      sign_in admin
      get :new
      assigns(:announcement).should be_a_new(Discussion)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :new
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :new
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member without permissions" do
      sign_in member
      get :new
      response.should be_forbidden
    end
  end

  describe "GET edit" do
    it "assigns the requested announcement as @announcement when authenticated as a admin" do
      sign_in admin
      get :edit, :id => announcement.id.to_s
      assigns(:announcement).should eq(announcement)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :edit, :id => announcement.id.to_s
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :edit, :id => announcement.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when member" do
      sign_in member
      get :edit, :id => announcement.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST create when authenticated as admin" do
    before(:each) {
      sign_in admin
    }
  
    describe "with valid params" do
      it "creates a new Announcement" do
        space
        expect {
          post :create, :announcement => announcement_attr
        }.to change(Announcement, :count).by(1)
      end

      it "assigns a newly created announcement as @announcement" do
        post :create, :announcement => announcement_attr
        assigns(:announcement).should be_a(Announcement)
        assigns(:announcement).should be_persisted
      end

      it "redirects to the created announcement" do
        post :create, :announcement => announcement_attr
        some_announcement = Announcement.unscoped.last
        response.should redirect_to(announcement_url(some_announcement))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved announcement as @announcement" do
        post :create, :announcement => announcement_attr
        assigns(:announcement).should be_a_new(Announcement)
      end

      it "re-renders the 'new' template" do
        post :create, :announcement => announcement_attr
        response.should render_template("new")
      end
    end
  end
  
  describe "POST create" do
    it "should redirect to new user session path when not authenticated as a user" do
      post :create, :announcement => announcement_attr
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :create, :announcement => announcement_attr
      response.should be_forbidden
    end
    
    it "should respond forbidden when user is member" do
      sign_in member
      post :create, :announcement => announcement_attr
      response.should be_forbidden
    end
  end

  describe "PUT update when authenticated as admin" do
    before(:each) {
      sign_in admin
    }
  
    describe "with valid params" do
      it "updates the requested announcement" do
        announcement
        put :update, :id => announcement.id, :announcement => {:name => "New name"}
        Announcement.find(announcement).name.should eql "New name"
      end

      it "assigns the requested announcement as @announcement" do
        put :update, :id => announcement.id, :announcement => {:name => "New name"}
        assigns(:announcement).should eq(announcement)
      end

      it "redirects to the discussion" do
        put :update, :id => announcement.id, :announcement => {:name => "New name"}
        response.should redirect_to(announcement_url(announcement))
      end
      
      it "should set has_been_edit to true" do
        put :update, :id => announcement.id, :announcement => {:name => "New name"}
        Announcement.find(announcement).has_been_edited.should be_true
      end
    end

    describe "with invalid params" do
      it "assigns the announcement as @announcement" do
        put :update, :id => announcement.id.to_s, :announcement => {:name => nil}
        assigns(:announcement).should eq(announcement)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => announcement.id.to_s, :announcement => {:name => nil}
        response.should render_template("edit")
      end
    end
  end

  describe "PUT update" do
    it "should redirect to new user session path when not authenticated as a user" do
      put :update, :id => announcement.id, :announcement => {:name => "New name"}
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      put :update, :id => announcement.id, :announcement => {:name => "New name"}
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not admin" do
      sign_in member
      put :update, :id => announcement.id, :announcement => {:name => "New name"}
      response.should be_forbidden
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested discussion when authenticated as admin" do
      announcement
      sign_in admin
      expect {
        delete :destroy, :id => announcement.id.to_s
      }.to change(Announcement, :count).by(-1)
    end

    it "redirects to the announcements list when authenticated as admin" do
      sign_in admin
      delete :destroy, :id => announcement.id.to_s
      response.should redirect_to(announcement_index)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      delete :destroy, :id => announcement.id.to_s
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      delete :destroy, :id => announcement.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not admin" do
      sign_in member
      delete :destroy, :id => announcement.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST lock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
    }
  
    it "should lock the announcement when authenticated as community admin" do
      sign_in admin
      post :lock, :id => announcement.id.to_s
      Announcement.find(announcement).is_locked.should be_true
    end
    
    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :lock, :id => announcement.id.to_s
      response.should redirect_to("/")
    end
    
    it "should not lock the announcement when authenticated as a member" do
      sign_in member
      post :lock, :id => announcement.id.to_s
      Announcement.find(announcement).is_locked.should be_false    
    end
    
    it "should not lock the announcement when not authenticated as a user" do
      post :lock, :id => announcement.id.to_s
      Announcement.find(announcement).is_locked.should be_false 
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      post :lock, :id => announcement.id.to_s
      response.should redirect_to(new_user_session_url) 
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :lock, :id => announcement.id.to_s
      response.should be_forbidden
    end
  end
  
  describe "POST unlock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
      announcement.is_locked = true
      announcement.save
    }
  
    it "should unlock the announcement when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => announcement.id.to_s
      Announcement.find(announcement).is_locked.should be_false
    end
    
    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => announcement.id.to_s
      response.should redirect_to("/")
    end
    
    it "should not unlock the announcement when authenticated as a member" do
      sign_in member
      post :unlock, :id => announcement.id.to_s
      Announcement.find(announcement).is_locked.should be_true    
    end
    
    it "should not unlock the announcement when not authenticated as a user" do
      post :unlock, :id => announcement.id.to_s
      Announcement.find(announcement).is_locked.should be_true 
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      post :unlock, :id => announcement.id.to_s
      response.should redirect_to(new_user_session_url) 
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :unlock, :id => announcement.id.to_s
      response.should be_forbidden
    end
  end
end
