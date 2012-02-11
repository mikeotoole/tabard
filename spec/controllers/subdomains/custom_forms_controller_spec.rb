require 'spec_helper'
require "cancan/matchers"

describe Subdomains::CustomFormsController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { DefaultObjects.community }
  let(:custom_form) { DefaultObjects.custom_form }
  let(:unpublished_form) { create(:custom_form, :is_published => false) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET index" do
    it "assigns all custom_forms as @custom_forms when authenticated as a user" do
      sign_in admin
      custom_form
      get :index
      assigns(:custom_forms).should eq([community.community_application_form, custom_form])
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :index
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET show" do
    it "should throw routing error when user" do
      assert_raises(AbstractController::ActionNotFound) do
        sign_in user
        get :show, :id => custom_form.id.to_s
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(AbstractController::ActionNotFound) do
        sign_in admin
        get :show, :id => custom_form.id.to_s
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(AbstractController::ActionNotFound) do
        get :show, :id => custom_form.id.to_s
        assert_response :missing
      end
    end
  end

  describe "GET new" do
    it "assigns a new custom_form as @custom_form when authenticated as a user" do
      sign_in admin
      get :new
      assigns(:custom_form).should be_a_new(CustomForm)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :new
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET edit" do
    it "assigns the requested custom_form as @custom_form when authenticated as a user" do
      sign_in admin
      get :edit, :id => custom_form
      assigns(:custom_form).should eq(custom_form)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :edit, :id => custom_form.id.to_s
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CustomForm" do
        sign_in admin
        expect {
          post :create, :custom_form =>  attributes_for(:custom_form)
        }.to change(CustomForm, :count).by(1)
      end

      it "assigns a newly created custom_form as @custom_form" do
        sign_in admin
        post :create, :custom_form => attributes_for(:custom_form)
        assigns(:custom_form).should be_a(CustomForm)
        assigns(:custom_form).should be_persisted
      end

      it "redirects to the created custom_form" do
        sign_in admin
        post :create, :custom_form => attributes_for(:custom_form)
        response.should redirect_to(custom_forms_url)
      end
      
      it "should redirected to new user session path when not authenticated as a user" do
        post :create, :custom_form => attributes_for(:custom_form)
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "with invalid params" do
      before(:each) {
        sign_in admin
        post :create, :custom_form => {}
      }
    
      it "assigns a newly created but unsaved custom_form as @custom_form" do 
        assigns(:custom_form).should be_a_new(CustomForm)
      end

      it "re-renders the 'new' template" do
        response.should render_template(:new)
      end
    end
  end

  describe "GET thankyou" do
    it "assigns the requested custom_form as @custom_form when authenticated as a user" do
      sign_in admin
      get :thankyou, :id => custom_form
      assigns(:custom_form).should eq(custom_form)
    end
    
    it "renders the thankyou template when authenticated as a user" do
      sign_in admin
      get :thankyou, :id => custom_form
      response.should render_template('thankyou')
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :thankyou, :id => custom_form.id.to_s
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "PUT update" do
    before(:each) {
      sign_in admin
      custom_form
    }
    describe "with valid params" do    
      it "updates the requested custom_form" do
        put :update, :id => custom_form.id, :custom_form => {:name => "New Name"}
        CustomForm.find(custom_form).name.should eq( "New Name")
      end

      it "assigns the requested custom_form as @custom_form" do
        put :update, :id => custom_form.id, :custom_form => attributes_for(:custom_form)
        assigns(:custom_form).should eq(custom_form)
      end

      it "redirects to the custom_form" do
        put :update, :id => custom_form.id, :custom_form => attributes_for(:custom_form)
        response.should redirect_to(custom_forms_url)
      end
    end

    describe "with invalid params" do
      it "assigns the custom_form as @custom_form" do
        put :update, :id => custom_form.id.to_s, :custom_form => {:name => nil}
        assigns(:custom_form).should eq(custom_form)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => custom_form.id.to_s, :custom_form => {:name => nil}
        response.should render_template("edit")
      end
    end
  end

  describe "PUT publish" do
    before(:each) {
      custom_form
      unpublished_form
    }
    describe "as Admin" do
      before(:each) {
        sign_in admin
      }
      it "should publish an unpublished form" do
        put :publish, :id => unpublished_form
        CustomForm.find(unpublished_form).is_published.should be_true
      end
      it "should do nothing to a published form" do
        put :publish, :id => custom_form
        CustomForm.find(custom_form).is_published.should be_true
      end
    end
    describe "as member" do
      before(:each) {
        sign_in user
      }
      it "should be forbidden for an unpublished form" do
        put :publish, :id => unpublished_form
        response.should be_forbidden
      end
      it "should forbidden for a published form" do
        put :publish, :id => custom_form
        response.should be_forbidden
      end
    end
  end

  describe "PUT unpublish" do
    before(:each) {
      custom_form
      unpublished_form
    }
    describe "as Admin" do
      before(:each) {
        sign_in admin
      }
      it "should unpublish an published form" do
        put :unpublish, :id => custom_form
        CustomForm.find(custom_form).is_published.should be_false
      end
      it "should do nothing to a unpublished form" do
        put :unpublish, :id => unpublished_form
        CustomForm.find(unpublished_form).is_published.should be_false
      end
    end
    describe "as member" do
      before(:each) {
        sign_in user
      }
      it "should be forbidden for an unpublished form" do
        put :unpublish, :id => unpublished_form
        response.should be_forbidden
      end
      it "should forbidden for a published form" do
        put :unpublish, :id => custom_form
        response.should be_forbidden
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested custom_form" do
      sign_in admin
      custom_form
      expect {
        delete :destroy, :id => custom_form.id.to_s
      }.to change(CustomForm, :count).by(-1)
    end

    it "redirects to the custom_forms list" do
      sign_in admin
      delete :destroy, :id => custom_form.id.to_s
      response.should redirect_to(custom_forms_url)
    end
  end

end
