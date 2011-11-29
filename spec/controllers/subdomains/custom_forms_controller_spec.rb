require 'spec_helper'
require "cancan/matchers"

describe Subdomains::CustomFormsController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { DefaultObjects.community }
  let(:custom_form) { DefaultObjects.custom_form }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET index" do
    it "assigns all custom_forms as @custom_forms when authenticated as a user" do
      sign_in user
      custom_form
      get :index
      assigns(:custom_forms).should eq([community.community_application_form, custom_form])
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :index
      response.should redirect_to(new_user_session_url(:subdomain => "secure", :protocol => "https://"))
    end
  end

  describe "GET show" do
    it "assigns the requested custom_form as @custom_form when authenticated as a user" do
      sign_in user
      get :show, :id => custom_form.id.to_s
      assigns(:custom_form).should eq(custom_form)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :show, :id => custom_form.id.to_s
      response.should redirect_to(new_user_session_url(:subdomain => "secure", :protocol => "https://"))
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
      response.should redirect_to(new_user_session_url(:subdomain => "secure", :protocol => "https://"))
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
      response.should redirect_to(new_user_session_url(:subdomain => "secure", :protocol => "https://"))
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
        response.should redirect_to(custom_form_url(2))
      end
      
      it "should redirected to new user session path when not authenticated as a user" do
        post :create, :custom_form => attributes_for(:custom_form)
        response.should redirect_to(new_user_session_url(:subdomain => "secure", :protocol => "https://"))
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
        response.should render_template("new")
      end
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
        response.should redirect_to(custom_form)
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
