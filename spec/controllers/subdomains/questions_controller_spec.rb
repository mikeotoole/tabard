require 'spec_helper'

describe Subdomains::QuestionsController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:community) { DefaultObjects.community }
  let(:custom_form) { DefaultObjects.custom_form }
  let(:question) { create(:long_answer_question) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET index" do
    it "assigns all questions as @questions" do
      sign_in user
      question
      get :index, :custom_form_id => custom_form.id
      assigns(:questions).should eq([question])
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :index, :custom_form_id => custom_form.id
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET show" do
    it "assigns the requested question as @question" do
      sign_in user
      get :show, :id => question.id.to_s
      assigns(:question).should eq(question)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :show, :id => question.id.to_s
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET new" do
    it "assigns a new question as @question" do
      sign_in admin
      get :new, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question"
      assigns(:question).should be_a_new(TextQuestion)
      assigns(:question).style.should eq("long_answer_question")
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :new, :custom_form_id => custom_form.id
      response.should redirect_to(new_user_session_path)
    end    
  end

  describe "GET edit" do
    it "assigns the requested question as @question" do
      sign_in admin
      question
      get :edit, :id => question.id.to_s
      assigns(:question).should eq(question)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :edit, :id => question.id.to_s
      response.should redirect_to(new_user_session_path)
    end 
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Question" do
        expect {
          sign_in admin
          post :create, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question", :question => attributes_for(:long_answer_question)
        }.to change(Question, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        sign_in admin
        post :create, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question", :question => attributes_for(:long_answer_question)
        assigns(:question).should be_a(TextQuestion)
        assigns(:question).should be_persisted
      end

      it "redirects to the created question" do
        sign_in admin
        post :create, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question", :question => attributes_for(:long_answer_question)
        response.should redirect_to(custom_form_url(custom_form))
      end
      
      it "should redirected to new user session path when not authenticated as a user" do
        post :create, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question", :question => attributes_for(:long_answer_question)
        response.should redirect_to(new_user_session_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        sign_in admin
        post :create, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question", :question => {:body => nil}
        assigns(:question).should be_a_new(Question)
      end

      it "re-renders the 'new' template" do
        sign_in admin
        post :create, :custom_form_id => custom_form.id, :question_type => "TextQuestion|long_answer_question", :question => {:body => nil}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested question" do
        sign_in admin
        put :update, :id => question.id, :question => {:body => "New body"}
        Question.find(question).body.should eq("New body")
      end

      it "assigns the requested question as @question" do
        sign_in admin
        put :update, :id => question.id, :question => attributes_for(:long_answer_question)
        assigns(:question).should eq(question)
      end
      
      it "assigns the requested question as a new question if it has answers" do
        sign_in admin
        my_question = create(:answer).question
        put :update, :id => my_question, :question => {:body => "My new question body"}
        assigns(:question).should_not eq(my_question)
        assigns(:question).should be_a(Question)
        assigns(:question).should eq(Question.last)
        Question.find(my_question).custom_form.should be_nil
      end

      it "redirects to the question" do
        sign_in admin
        put :update, :id => question.id, :question => {:body => "My new question body"}
        response.should redirect_to(custom_form_url(custom_form))
      end
    end

    describe "with invalid params" do
      it "assigns the question as @question" do
        sign_in admin
        put :update, :id => question.id.to_s, :question => {:body => nil}
        assigns(:question).should eq(question)
      end

      it "re-renders the 'edit' template" do
        sign_in admin
        put :update, :id => question.id.to_s, :question => {:body => nil}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question when it has no answers" do
      question.answers.empty?.should be_true
      expect {
        sign_in admin
        delete :destroy, :id => question.id.to_s
      }.to change(Question, :count).by(-1)
    end
    
    it "does not destroy the requested question when it has answers" do
      sign_in admin
      question = create(:answer).question
      question.answers.empty?.should be_false
      expect {
        delete :destroy, :id => question.id.to_s
      }.to change(Question, :count).by(0)
      Question.find(question).custom_form.should be_nil
    end

    it "redirects to the questions custom form" do
      sign_in admin
      delete :destroy, :id => question.id.to_s
      response.should redirect_to(custom_form_url(question))
    end
  end

end
