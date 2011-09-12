require 'spec_helper'

describe BaseCharactersController do
  let(:user) { Factory.create(:user) }
  
  describe "GET 'new'" do
    describe "when not authenticated as a user" do
      it "shouldn't be successful" do
        get 'new', :game => {:game_id => DefaultObjects.wow.id}
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "when authenticated as a user" do
      it "should be successful" do
        sign_in user
        get 'new', :game => {:game_id => DefaultObjects.wow.id}
        response.should redirect_to(new_wow_character_path)
      end
      
      it "should redirect to new swtor character path when game is Swtor" do
        sign_in user
        get 'new', :game => {:game_id => DefaultObjects.swtor.id}
        response.should redirect_to(new_swtor_character_path)
      end
      
      it "should redirect to new wow character path when game is Wow" do
        sign_in user
        get 'new', :game => {:game_id => DefaultObjects.wow.id}
        response.should redirect_to(new_wow_character_path)
      end
      
      it "should redirect back when game is nil" do
        sign_in user
        request.env["HTTP_REFERER"] = "/"
        get 'new', :game => {:game_id => nil}
        response.should redirect_to("/")
      end
    end
  end
end
