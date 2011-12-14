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
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get :index, :submission_id => submission.id
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin
        get :index, :submission_id => submission.id
        assert_response :missing
      end
    end
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get :index, :submission_id => submission.id
        assert_response :missing
      end
    end
  end

  describe "GET show" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get :show, :submission_id => submission.id, :id => answer.id.to_s
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin
        get :show, :submission_id => submission.id, :id => answer.id.to_s
        assert_response :missing
      end
    end
    
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get :show, :submission_id => submission.id, :id => answer.id.to_s
        assert_response :missing
      end
    end 
  end

  describe "GET new" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        get :new, :submission_id => submission.id
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin
        get :new, :submission_id => submission.id
        assert_response :missing
      end
    end
    
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        get :new, :submission_id => submission.id
        assert_response :missing
      end
    end   
  end

  describe "POST create" do
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        post :create, :submission_id => create(:submission).id, :answer => attributes_for(:answer)
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin
        post :create, :submission_id => create(:submission).id, :answer => attributes_for(:answer)
        assert_response :missing
      end
    end
    
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        post :create, :submission_id => create(:submission).id, :answer => attributes_for(:answer)
        assert_response :missing
      end
    end
    it "should throw routing error when user" do
      assert_raises(ActionController::RoutingError) do
        sign_in user
        post :create, :submission_id => create(:submission).id, :answer => {}
        assert_response :missing
      end
    end
    it "should throw routing error when admin" do
      assert_raises(ActionController::RoutingError) do
        sign_in admin
        post :create, :submission_id => create(:submission).id, :answer => {}
        assert_response :missing
      end
    end
    
    it "should throw routing error when anon" do
      assert_raises(ActionController::RoutingError) do
        post :create, :submission_id => create(:submission).id, :answer => {}
        assert_response :missing
      end
    end
  end
end
