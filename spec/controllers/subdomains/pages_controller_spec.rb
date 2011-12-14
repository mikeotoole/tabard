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

describe Subdomains::PagesController do
  let(:owner) { DefaultObjects.user }
  let(:non_owner) { 
    profile = create(:user_profile)
    DefaultObjects.community.promote_user_profile_to_member(profile)
    profile.user
  }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }
  let(:page) { create(:page) }
  let(:space) { DefaultObjects.page_space }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET index" do
    it "assigns all pages as @pages when authenticated as a member" do
      page.page_space_id.should eq(space.id)
      sign_in owner
      get :index, :page_space_id => space.id
      assigns(:pages).should eq([page])
    end
    
    it "should render the 'index' template when authenticated as a member" do
      sign_in owner
      get :index, :page_space_id => space.id
      response.should render_template("index")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :index, :page_space_id => space.id
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :index, :page_space_id => space.id
      response.should be_forbidden
    end    
  end

  describe "GET show" do
    it "assigns the requested discussion as @page when authenticated as a member" do
      sign_in owner
      get :show, :id => page.id.to_s
      assigns(:page).should eq(page)
    end
    
    it "should render the 'show' template when authenticated as a member" do
      sign_in owner
      get :show, :id => page.id.to_s
      response.should render_template("show")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :show, :id => page.id.to_s
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :show, :id => page.id.to_s
      response.should be_forbidden
    end   
  end

  describe "GET new" do
    it "assigns a new page as @page when authenticated as a member" do
      sign_in owner
      get :new, :page_space_id => space.id
      assigns(:page).should be_a_new(Page)
    end
    
    it "should render the 'new' template when authenticated as a member" do
      sign_in owner
      get :new, :page_space_id => space.id
      response.should render_template("new")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :new, :page_space_id => space.id
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :new, :page_space_id => space.id
      response.should be_forbidden
    end
  end

  describe "GET edit" do
    it "assigns the requested page as @page when authenticated as a owner" do
      sign_in owner
      get :edit, :id => page.id.to_s
      assigns(:page).should eq(page)
    end
    
    it "should render the 'edit' template when authenticated as a owner" do
      sign_in owner
      get :edit, :id => page.id.to_s
      response.should render_template("edit")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :edit, :id => page.id.to_s
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      get :edit, :id => page.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when not owner" do
      sign_in non_owner
      get :edit, :id => page.id.to_s
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
          post :create, :page_space_id => space.id, :page => attributes_for(:page)
        }.to change(Page, :count).by(1)
      end

      it "assigns a newly created page as @page" do
        post :create, :page_space_id => space.id, :page => attributes_for(:page)
        assigns(:page).should be_a(Page)
        assigns(:page).should be_persisted
      end

      it "redirects to the created page" do
        post :create, :page_space_id => space.id, :page => attributes_for(:page)
        response.should redirect_to(Page.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved page as @page" do
        post :create, :page_space_id => space.id, :page => attributes_for(:page, :name => nil)
        assigns(:page).should be_a_new(Page)
      end

      it "re-renders the 'new' template" do
        post :create, :page_space_id => space.id, :page => attributes_for(:page, :name => nil)
        response.should render_template("new")
      end
    end
  end
  
  describe "POST create" do
    it "should redirect to new user session path when not authenticated as a user" do
      post :create, :page_space_id => space.id, :page => attributes_for(:page)
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      post :create, :page_space_id => space.id, :page => attributes_for(:page)
      response.should be_forbidden
    end
  end

  describe "PUT update when authenticated as owner" do
    before(:each) {
      sign_in owner
    }
  
    describe "with valid params" do
      it "updates the requested page" do
        page
        # Assuming there are no other pages in the database, this
        # specifies that the Page created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Page.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => page.id, :page => {'these' => 'params'}
      end

      it "assigns the requested page as @page" do
        put :update, :id => page.id, :page => {:name => "New name"}
        assigns(:page).should eq(page)
      end

      it "redirects to the page" do
        put :update, :id => page.id, :page => {:name => "New name"}
        response.should redirect_to(page)
      end
    end

    describe "with invalid params" do
      it "assigns the page as @page" do
        put :update, :id => page.id.to_s, :page => {:name => nil}
        assigns(:page).should eq(page)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => page.id.to_s, :page => {:name => nil}
        response.should render_template("edit")
      end
    end
  end

  describe "PUT update" do
    it "should redirect to new user session path when not authenticated as a user" do
      put :update, :id => page.id, :page => {:name => "New name"}
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      put :update, :id => page.id, :page => {:name => "New name"}
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not owner" do
      sign_in non_owner
      put :update, :id => page.id, :page => {:name => "New name"}
      response.should be_forbidden
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested page when authenticated as owner" do
      page
      sign_in owner
      expect {
        delete :destroy, :id => page.id.to_s
      }.to change(Page, :count).by(-1)
    end

    it "redirects to the page list when authenticated as owner" do
      sign_in owner
      delete :destroy, :id => page.id.to_s
      response.should redirect_to(page.page_space)
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      delete :destroy, :id => page.id.to_s
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not a member" do
      sign_in non_member
      delete :destroy, :id => page.id.to_s
      response.should be_forbidden
    end
    
    it "should respond forbidden when a member but not owner" do
      sign_in non_owner
      delete :destroy, :id => page.id.to_s
      response.should be_forbidden
    end
  end
  
end
