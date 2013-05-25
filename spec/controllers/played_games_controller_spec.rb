require 'spec_helper'

describe PlayedGamesController do
  let(:user_profile) { DefaultObjects.user_profile }
  let(:user) { user_profile.user }
  # Uses spec/support/default_params.rb to make 'default subdomain: false' block work with tests.
  let(:default_params) { {subdomain: false} }

  describe "GET 'index'" do
    it "should show the index" do
      sign_in user
      xhr :get, 'index', user_profile_id: user_profile.id
      response.should be_success
    end
  end

  describe "GET 'autocomplete'" do
    it "should autocomplete the term" do
      the_game = DefaultObjects.wow
      sign_in user
      get 'autocomplete', term: "World"
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should show the new" do
      sign_in user
      get 'new', user_profile_id: user_profile.id
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should create the game" do
      sign_in user
      post 'create', user_profile_id: user_profile.id, played_game_attributes: FactoryGirl.attributes_for(:minecraft_played_game)
      response.should redirect_to(redirect_to user_profile_url(user_profile, anchor: "games"))
    end
  end

  describe "DELETE 'destroy'" do
    it "should delete the game" do
      played_game = create(:minecraft_played_game)
      sign_in user
      delete 'destroy', user_profile_id: user_profile.id, id: played_game.id
      response.should redirect_to(redirect_to user_profile_url(user_profile, anchor: "games"))
    end
  end
end

