require 'spec_helper'

describe SwtorCharactersController do
  let(:valid_attributes) { attributes_for(:swtor_character_att) }

  before(:each) do
    @user_profile = DefaultObjects.user_profile
    @user = DefaultObjects.user
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
  
    it "should be successful when not authenticated as a user" do
      get 'show', :id => @character
      response.should be_success
    end
  end

  describe "GET 'new'" do
    pending
  end  
  
  describe "GET 'edit'" do
    before(:each) do
      @character = Factory.create(:swtor_char_profile)
    end
  
    it "should be successful when authenticated as an authorized user" do
      sign_in @user
      get 'edit', :id => @character
      response.should be_success
    end
    
        
    it "should render swtor_characters/edit template when authenticated as an authorized user" do
      sign_in @user
      get 'edit', :id => @character
      response.should render_template('swtor_characters/edit')
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => @character
      response.should redirect_to(new_user_session_path)
    end
    
    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      get 'edit', :id => @character
      response.should be_forbidden
    end
  end
  
  describe "POST 'create' when authenticated as a user" do
    before(:each) do
      sign_in @user
    end
    
    it "should add new character" do
      expect {
          post :create, :swtor_character => valid_attributes
        }.to change(SwtorCharacter, :count).by(1)
    end
    
    it "should pass params to swtor_character" do
      post :create, :swtor_character => valid_attributes
      assigns(:swtor_character).should be_a(SwtorCharacter)
      assigns(:swtor_character).should be_persisted
    end
    
    it "should redirect to new swtor character" do
      post :create, :swtor_character => valid_attributes
      response.should redirect_to(SwtorCharacter.last)
    end
  end
  
  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      @game = DefaultObjects.swtor
      post 'create', :swtor_character => valid_attributes
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
      SwtorCharacter.find(1).name.should eq(@new_name)
    end
    
    it "should redirect to swtor character" do
      response.should redirect_to(swtor_character_path(assigns[:swtor_character]))
    end
  end  
  
  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @characterDefault = Factory.create(:swtor_char_profile)
      @characterNotDefault = Factory.create(:swtor_char_profile)
      sign_in @user
    end
  
    it "should update default when set to true" do
      SwtorCharacter.find(@characterNotDefault).default.should be_false
      put 'update', :id => @characterNotDefault, :swtor_character => { :default => true }
      SwtorCharacter.exists?(@characterNotDefault).should be_true
      SwtorCharacter.find(@characterNotDefault).default.should be_true
    end
    
    it "should not update default when set from true to false" do
      SwtorCharacter.find(@characterDefault).default.should be_true
      put 'update', :id => @characterDefault, :swtor_character => { :default => false }
      SwtorCharacter.exists?(@characterDefault).should be_true
      SwtorCharacter.find(@characterDefault).default.should be_true
    end
  end
  
  it "PUT 'update' should respond forbidden when authenticated as an unauthorized user" do
    @character = Factory.create(:swtor_char_profile)
    some_user_profile = create(:user_profile)
    sign_in some_user_profile.user
    put 'update', :id => @character, :swtor_character => { :name => "My New Name" }
    response.should be_forbidden
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
    
    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      delete 'destroy', :id => @character
      response.should be_forbidden
    end
  end
end
