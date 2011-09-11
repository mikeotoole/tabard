require 'spec_helper'

describe GamesController do
  before(:each) do
    @user = DefaultObjects.user
    @game = DefaultObjects.wow
  end
  
  describe "GET 'show'" do
    it "should be successful when authenticated as a user" do
      sign_in @user
      get 'show', :id => @game
      response.should be_success
    end
  
    it "shouldn't be successful when not authenticated as a user" do
      get 'show', :id => @game
      response.should redirect_to(new_user_session_path)
    end
  end
end
