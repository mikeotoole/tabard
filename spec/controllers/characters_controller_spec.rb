require 'spec_helper'

describe CharactersController do
  let(:valid_attributes) { attributes_for(:swtor_character_att) }
  let(:character) { create(:swtor_character) }
  let(:user) { character.user_profile.user }
  let(:played_game) { character.played_game }

  describe "GET 'show'" do
    it "should throw routing error" do
      assert_raises(ActionController::RoutingError) do
        get 'show'
        assert_response :missing
      end
    end
  end

  describe "GET 'new'" do
    it "should be successful when authenticated as user" do
      sign_in user
      get 'new', played_game_id: played_game
      response.should be_success
    end

    it "shouldn't be successful when not authenticated as a user" do
      get 'new', played_game_id: played_game
      response.should redirect_to(new_user_session_url(subdomain: 'secure'))
    end

    it "should render characters/new template" do
      sign_in user
      get 'new', played_game_id: played_game
      response.should render_template('characters/new')
    end
  end

  describe "GET 'edit'" do
    it "should be successful when authenticated as an authorized user" do
      sign_in user
      get 'edit', :id => character
      response.should be_success
    end


    it "should render characters/edit template when authenticated as an authorized user" do
      sign_in user
      get 'edit', :id => character
      response.should render_template('characters/edit')
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => character
      response.should redirect_to(new_user_session_url(subdomain: 'secure'))
    end

    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      get 'edit', :id => character
      response.should be_forbidden
    end
  end

  describe "POST 'create' when authenticated as a user" do
    before(:each) do
      sign_in user
    end

    it "should add new character" do
      expect {
        post :create, :played_game_id => played_game, :character => valid_attributes
      }.to change(Character, :count).by(1)
    end

    it "should pass params to character" do
      post :create, :played_game_id => played_game, :character => valid_attributes
      assigns(:character).should be_a(Character)
      assigns(:character).should be_persisted
    end

    it "should redirect to user profile games tab" do
      post :create, :played_game_id => played_game, :character => valid_attributes
      response.should redirect_to(user_profile_url(user.user_profile, subdomain: 'www') + "#games")
    end

    it "should create an activity" do
      expect {
        post :create, :played_game_id => played_game, :character => valid_attributes
      }.to change(Activity, :count).by(1)

      activity = Activity.last
      activity.target_type.should eql "Character"
      activity.action.should eql 'created'
    end
  end

  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post :create, :played_game_id => played_game, :character => valid_attributes
    end

    it "should not create new record" do
      assigns[:character].should be_nil
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure'))
    end
  end

  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @new_name = 'My new name.'
      sign_in user
      put 'update', :id => character, :character => { :name => @new_name }
    end

    it "should change attributes" do
      Character.find(character).name.should eq(@new_name)
    end

    it "should redirect user profile games tab" do
      response.should redirect_to(user_profile_url(user.user_profile, subdomain: 'www') + "#games")
    end

    it "should create an Activity when attributes change" do
      activity = Activity.last
      activity.target_type.should eql "Character"
      activity.action.should eql 'edited'
    end
  end

  describe "PUT 'update' when authenticated as owner" do
    it "should not create an Activity when attributes don't change" do
      sign_in user
      name = character.name
      expect {
        put 'update', :id => character, :character => { :name => name }
      }.to change(Activity, :count).by(1)
    end
  end

  it "PUT 'update' should respond forbidden when authenticated as an unauthorized user" do
    some_user_profile = create(:user_profile)
    sign_in some_user_profile.user
    put 'update', :id => character, :character => { :name => "My New Name" }
    response.should be_forbidden
  end

  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      put 'update', :id => character, :character => { :name => 'My new name.' }
    end

    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure'))
    end

    it "should not change attributes" do
      assigns[:character].should be_nil
    end
  end

  describe "DELETE 'destroy'" do
    it "should be successful when authenticated as a user" do
      sign_in user
      delete 'destroy', :id => character
      response.should redirect_to(user_profile_url(character.user_profile, subdomain: 'www') + "#games")
    end

    it "should redirected to new user session path when not authenticated as a user" do
      delete 'destroy', :id => character
      response.should redirect_to(new_user_session_url(subdomain: 'secure'))
    end

    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      delete 'destroy', :id => character
      response.should be_forbidden
    end
  end
end
