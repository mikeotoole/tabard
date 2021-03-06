require 'spec_helper'

describe Subdomains::SubmissionsController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { DefaultObjects.community }
  let(:custom_form) { DefaultObjects.custom_form }
  let(:submission) { create(:submission) }

  before(:each) do
    @request.host = "#{community.subdomain}.lvh.me:3000"
  end

  describe "GET index" do
    it "assigns all submissions as @submissions" do
      sign_in user
      submission
      get :index, :custom_form_id => custom_form.id
      assigns(:submissions).should eq([submission])
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get :index, :custom_form_id => custom_form.id
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET show" do
    it "assigns the requested submission as @submission" do
      sign_in user
      submission
      get :show, :custom_form_id => custom_form.id, :id => submission.id.to_s
      assigns(:submission).should eq(submission)
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get :show, :custom_form_id => custom_form.id, :id => submission.id.to_s
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "GET new" do
    it "assigns a new submission as @submission" do
      sign_in user
      get :new, :custom_form_id => custom_form.id
      assigns(:submission).should be_a_new(Submission)
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get :new, :custom_form_id => custom_form.id
      response.should redirect_to(new_user_session_url)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Submission" do
        sign_in user
        expect {
          post :create, :custom_form_id => custom_form.id, :submission => attributes_for(:submission)
        }.to change(Submission, :count).by(3)
      end

      it "assigns a newly created submission as @submission" do
        sign_in user
        post :create, :custom_form_id => custom_form.id, :submission => attributes_for(:submission)
        assigns(:submission).should be_a(Submission)
        assigns(:submission).should be_persisted
      end

      it "redirects to the community root" do
        sign_in user
        post :create, :custom_form_id => custom_form.id, :submission => attributes_for(:submission)
        response.should redirect_to(custom_form_thankyou_url(assigns(:submission).custom_form))
      end

      it "should redirected to new user session path when not authenticated as a user" do
        post :create, :custom_form_id => custom_form.id, :submission => attributes_for(:submission)
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested submission" do
    	sign_in user
      submission
      expect {
        delete :destroy, :id => submission.id.to_s
      }.to change(Submission, :count).by(-1)
    end

    it "redirects to the submissions list" do
      sign_in user
      delete :destroy, :id => submission.id.to_s
      response.should redirect_to(custom_form_submissions_url(submission.custom_form, subdomain: community.subdomain))
    end

    it "should redirected to new user session path when not authenticated as a user" do
      delete :destroy, :id => submission.id.to_s
      response.should redirect_to(new_user_session_url)
    end
  end

end
