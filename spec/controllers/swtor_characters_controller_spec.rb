require 'spec_helper'

describe SwtorCharactersController do
  before(:each) do
    @user = DefaultObjects.user
    @user_profile = DefaultObjects.user_profile
  end
  
  describe "GET 'show'" do
    before(:each) do
      @character = Factory.create(:swtor_char_profile)
    end
    
    it "should be successful when authenticated as a user" do
      sign_in @user
      get 'show', :id => @character
      response.should be_success
    end
  
    it "shouldn't be successful when not authenticated as a user" do
      get 'show', :id => @character
      response.should redirect_to(new_user_session_path)
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @character = Factory.create(:swtor_char_profile)
    end
  
    it "should be successful when authenticated as a user" do
      sign_in @user
      get 'edit', :id => @character
      response.should be_success
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => @character
      response.should redirect_to(new_user_session_path)
    end
    
    it "should render swtor_characters/edit template" do
      sign_in @user
      get 'edit', :id => @character
      response.should render_template('swtor_characters/edit')
    end
  end
  
  describe "POST 'create' when authenticated as a user" do
    before(:each) do
      sign_in @user
      @game = Swtor.new(:name => "My SWTOR")
      @game.save
      post 'create', :swtor_character => {:name => "My Test Name", :game_id => @game.id}
    end
    
    it "should add new character" do
      SwtorCharacter.exists?(1).should be_true
    end
    
    it "should pass params to swtor_character" do
      SwtorCharacter.find(1).name.should == "My Test Name"
    end
    
    it "should redirect to new swtor character" do
      response.should redirect_to(swtor_character_path(1))
    end
  end
  
  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      @game = Swtor.new(:name => "My SWTOR")
      @game.save
      post 'create', :swtor_character => {:name => "TestName", :game_id => @game.id}
    end
    
    it "should not create new record" do
      assigns[:swtor_character].should be_nil
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end
  end   

  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @character = Factory.create(:swtor_char_profile)
      @new_name = 'My new name.'
      sign_in @user
      put 'update', :id => @character, :swtor_character => { :name => @new_name }
    end
  
    it "should change attributes" do
      SwtorCharacter.find(1).name.should == @new_name
    end
    
    it "should redirect to swtor character" do
      response.should redirect_to(swtor_character_path(assigns[:swtor_character]))
    end
  end  
  
  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @character = Factory.create(:swtor_char_profile)
      put 'update', :id => @character, :swtor_character => { :name => 'My new name.' }
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
    end  
    
    it "should not change attributes" do
      assigns[:swtor_character].should be_nil
    end    
  end 

  describe "DELETE 'destroy'" do
    before(:each) do
      @character = Factory.create(:swtor_char_profile)
    end
  
    it "should be successful when authenticated as a user" do
      sign_in @user
      delete 'destroy', :id => @character
      response.should redirect_to(swtor_characters_path)
    end
 
    it "should redirected to new user session path when not authenticated as a user" do
      delete 'destroy', :id => @character
      response.should redirect_to(new_user_session_path)
    end
  end
end
