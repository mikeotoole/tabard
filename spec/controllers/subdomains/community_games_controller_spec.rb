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

describe Subdomains::CommunityGamesController do
  let(:member) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }

  let(:community_game) { create(:community_game) }
  let(:valid_attributes) { attributes_for(:community_game_att) }

  before(:each) do
    @request.host = "#{community.subdomain}.lvh.me:3000"
  end

  describe "GET index" do
    it "assigns all community_games as @community_games when authenticated as a member" do
      sign_in member
      get :index
      assigns(:community_games).should eq(community.community_games.includes(:community))
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :index
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :index
      response.should be_forbidden
    end
  end

  describe "GET show" do
    it "should redirect to status code not found path when authenticated as a member" do
      assert_raises(ActionController::RoutingError) do
        sign_in member
        community_game
        get :show, :id => community_game.id
      end
    end

    it "should redirect to status code not found path when not authenticated as a user" do
      assert_raises(ActionController::RoutingError) do
        get :show, :id => community_game
      end
    end

    it "should redirect to status code not found path when not a member" do
      assert_raises(ActionController::RoutingError) do
        sign_in non_member
        get :show, :id => community_game
      end
    end
  end

  describe "GET new" do
    it "assigns a new community_game as @community_game when authenticated as community admin" do
      sign_in admin
      get :new
      assigns(:community_game).should be_a_new(CommunityGame)
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
    it "assigns the requested community_game as @community_game when authenticated as community admin" do
      sign_in admin
      community_game
      get :edit, :id => community_game.id
      assigns(:community_game).should eq(community_game)
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :edit, :id => community_game.id.to_s
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :edit, :id => community_game.id.to_s
      response.should be_forbidden
    end

    it "should respond forbidden when a member without permissions" do
      sign_in member
      get :edit, :id => community_game.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST create when authenticated as community admin" do
    before(:each) {
      sign_in admin
    }

    describe "with valid params" do
      it "creates a new CommunityGame" do
        expect {
          post :create, :community_game => valid_attributes
        }.to change(CommunityGame, :count).by(1)
      end

      it "assigns a newly created community_game as @community_game" do
        post :create, :community_game => valid_attributes
        assigns(:community_game).should be_a(CommunityGame)
        assigns(:community_game).should be_persisted
      end

      it "redirects to the created community_game" do
        post :create, :community_game => valid_attributes
        response.should redirect_to(community_games_path(subdomain: community.subdomain))
      end

      it "should create an activity" do
        expect {
          post :create, :community_game => valid_attributes
        }.to change(Activity, :count).by(1)

        activity = Activity.last
        activity.target_type.should eql "CommunityGame"
        activity.action.should eql 'created'
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved community_game as @community_game" do
        post :create, :community_game => {:game_type => DefaultObjects.wow.class.name}
        assigns(:community_game).should be_a_new(CommunityGame)
      end

      it "re-renders the 'new' template" do
        post :create, :community_game => {:game_type => DefaultObjects.wow.class.name}
        response.should render_template("new")
      end

      it "should not create an activity" do
        expect {
          post :create, :community_game => {:game_type => DefaultObjects.wow.class.name}
        }.to change(Activity, :count).by(0)
      end
    end
  end

  describe "POST create" do
    it "should redirected to new user session path when not authenticated as a user" do
      post :create, :community_game => valid_attributes
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :create, :community_game => valid_attributes
      response.should be_forbidden
    end

    it "should respond forbidden when a member without permissions" do
      sign_in member
      post :create, :community_game => valid_attributes
      response.should be_forbidden
    end
  end

  describe "PUT update when authenticated as community admin" do
    before(:each) {
      sign_in admin
    }

    describe "with valid params" do
      it "updates the requested community_game" do
        put :update, :id => community_game.id, :community_game => {:faction => community_game.faction, :server_name => community_game.server_name}
        CommunityGame.find(community_game).server_name.should eql community_game.server_name
      end

      it "assigns the requested community_game as @community_game" do
        put :update, :id => community_game.id, :community_game => valid_attributes
        assigns(:community_game).should eq(community_game)
      end

      it "redirects to the community_game" do
        put :update, :id => community_game.id, :community_game => valid_attributes
        response.should redirect_to(community_games_path(subdomain: community.subdomain))
      end

      it "should create an Activity when attributes change" do
        put :update, :id => community_game.id, :community_game => valid_attributes
        activity = Activity.last
        activity.target_type.should eql "CommunityGame"
        activity.action.should eql 'edited'
      end

      it "should not create an Activity when attributes don't change" do
        community_game
        expect {
          put :update, :id => community_game.id, :community_game => {:faction => community_game.faction, :server_name => community_game.server_name}
        }.to change(Activity, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "assigns the community_game as @community_game" do
        put :update, :id => community_game.id, :community_game => {:game => nil}
        assigns(:community_game).should eq(community_game)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => community_game.id, :community_game => {:game => nil}
        response.should render_template("edit")
      end
    end
  end

  describe "PUT update" do
    it "should redirected to new user session path when not authenticated as a user" do
      put :update, :id => community_game.id, :community_game => valid_attributes
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      put :update, :id => community_game.id, :community_game => valid_attributes
      response.should be_forbidden
    end

    it "should respond forbidden when a member without permissions" do
      sign_in member
      put :update, :id => community_game.id, :community_game => valid_attributes
      response.should be_forbidden
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested community_game when authenticated as community admin" do
      sign_in admin
      community_game
      expect {
        delete :destroy, :id => community_game.id
      }.to change(CommunityGame, :count).by(-1)
    end

    it "redirects to the subdomains_community_games list when authenticated as community admin" do
      sign_in admin
      delete :destroy, :id => community_game.id
      response.should redirect_to(community_games_url)
    end

    it "should redirected to new user session path when not authenticated as a user" do
      delete :destroy, :id => community_game.id.to_s
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      delete :destroy, :id => community_game.id.to_s
      response.should be_forbidden
    end

    it "should respond forbidden when a member without permissions" do
      sign_in member
      delete :destroy, :id => community_game.id.to_s
      response.should be_forbidden
    end
  end

end
