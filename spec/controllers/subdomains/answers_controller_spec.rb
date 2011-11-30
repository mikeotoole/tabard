require 'spec_helper'

describe Subdomains::AnswersController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { DefaultObjects.community }
  let(:answer) { create(:answer) }
  let(:submission) { answer.submission }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end
  
  describe "GET index" do
    it "assigns all answers as @answers" do
      sign_in user
      answer
      get :index, :submission_id => submission.id
      assigns(:answers).should eq([answer])
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :index, :submission_id => submission.id
      response.should redirect_to(new_user_session_url)
    end    
  end

  describe "GET show" do
    it "assigns the requested answer as @answer" do
      sign_in user
      get :show, :id => answer.id.to_s
      assigns(:answer).should eq(answer)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :show, :id => answer.id.to_s
      response.should redirect_to(new_user_session_url)
    end  
  end

  describe "GET new" do
    it "assigns a new answer as @answer" do
      sign_in user
      get :new, :submission_id => submission.id
      assigns(:answer).should be_a_new(Answer)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :new, :submission_id => submission.id
      response.should redirect_to(new_user_session_url)
    end  
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Answer" do
        expect {
          sign_in user
          post :create, :submission_id => create(:submission).id, :answer => attributes_for(:answer)
        }.to change(Answer, :count).by(1)
      end

      it "assigns a newly created answer as @answer" do
        sign_in user
        post :create, :submission_id => create(:submission).id, :answer => attributes_for(:answer, :body => "Test answer")
        assigns(:answer).should be_a(Answer)
        Answer.last.body.should eq("Test answer")
      end

      it "redirects to the created answer" do
        sign_in user
        submission = create(:submission)
        post :create, :submission_id => submission.id, :answer => attributes_for(:answer)
        response.should redirect_to(submission_url(submission))
      end
      
      it "should redirected to new user session path when not authenticated as a user" do
        post :create, :submission_id => create(:submission).id, :answer => attributes_for(:answer)
        response.should redirect_to(new_user_session_url)
      end 
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved answer as @answer" do
        sign_in user
        post :create, :submission_id => create(:submission).id, :answer => {}
        assigns(:answer).should be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        sign_in user
        post :create, :submission_id => create(:submission).id, :answer => {}
        response.should render_template("new")
      end
    end
  end
end
