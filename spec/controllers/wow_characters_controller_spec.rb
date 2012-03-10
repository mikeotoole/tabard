require 'spec_helper'

describe WowCharactersController do
  let(:valid_attributes) { attributes_for(:wow_character_att, :name => "My Test Name") }
  let(:user) { DefaultObjects.user }
  
  describe "GET 'show'" do
    it "should throw routing error" do
      assert_raises(AbstractController::ActionNotFound) do
        get 'show'
        assert_response :missing
      end
    end
  end

  describe "GET 'new'" do
    it "should be successful when authenticated as user" do
      sign_in user
      get 'new'
      response.should be_success
    end

    it "shouldn't be successful when not authenticated as a user" do
      get 'new'
      response.should redirect_to(new_user_session_path)
    end

    it "should render wow_characters/new template" do
      sign_in user
      get 'new'
      response.should render_template('wow_characters/new')
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @character = Factory.create(:wow_char_profile)
    end
  
    it "should be successful when authenticated as a user" do
      sign_in user
      get 'edit', :id => @character
      response.should be_success
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => @character
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
    
    it "should render wow_characters/edit template" do
      sign_in user
      get 'edit', :id => @character
      response.should render_template('wow_characters/edit')
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
      sign_in user
      post 'create', :wow_character => valid_attributes, :server_name => DefaultObjects.wow.server_name, :faction => DefaultObjects.wow.faction
    end
    
    it "should add new character" do
      WowCharacter.exists?(1).should be_true
    end
    
    it "should pass params to wow_character" do
      WowCharacter.find(1).name.should == "My Test Name"
    end
    
    it "should redirect to user profile characters tab" do
      response.should redirect_to(user_profile_url(user.user_profile) + "#characters")
    end
  end
  
  describe "POST 'create' when authenticated as a user" do
    it "should create an activity" do
      sign_in user
      expect {
        post :create, :wow_character => valid_attributes, :server_name => DefaultObjects.wow.server_name, :faction => DefaultObjects.wow.faction
      }.to change(Activity, :count).by(1)
      
      activity = Activity.last
      activity.target_type.should eql "CharacterProxy"
      activity.action.should eql 'created'
    end
  end  
  
  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      post 'create', :wow_character => valid_attributes
    end
    
    it "should not create new record" do
      assigns[:wow_character].should be_nil
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end   

  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @character = Factory.create(:wow_char_profile)
      @new_name = 'My new name.'
      sign_in user
      put 'update', :id => @character, :wow_character => { :name => @new_name }
    end
  
    it "should change attributes" do
      WowCharacter.find(@character).name.should == @new_name
    end
    
    it "should redirect to user profile characters tab" do
      response.should redirect_to(user_profile_url(user.user_profile) + "#characters")
    end
    
    it "should create an Activity when attributes change" do
      activity = Activity.last
      activity.target_type.should eql "CharacterProxy"
      activity.action.should eql 'edited'
    end
  end
  
  describe "PUT 'update' when authenticated as owner" do
    it "should not create an Activity when attributes don't change" do
      sign_in user
      @character = create(:wow_char_profile)
      
      expect {
        put 'update', :id => @character, :wow_character => { :name => @character.name }
      }.to change(Activity, :count).by(0)
    end
  end
  
  it "PUT 'update' should respond forbidden when authenticated as an unauthorized user" do
    @character = Factory.create(:wow_char_profile)
    some_user_profile = create(:user_profile)
    sign_in some_user_profile.user
    put 'update', :id => @character, :wow_character => { :name => "My New Name" }
    response.should be_forbidden
  end  
  
  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @character = Factory.create(:wow_char_profile)
      put 'update', :id => @character, :wow_character => { :name => 'My new name.' }
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end  
    
    it "should not change attributes" do
      assigns[:wow_character].should be_nil
    end    
  end 

  describe "DELETE 'destroy'" do
    before(:each) do
      @character = Factory.create(:wow_char_profile)
    end
  
    it "should be successful when authenticated as a user" do
      sign_in user
      delete 'destroy', :id => @character
      response.should redirect_to(user_profile_url(@character.user_profile) + "#characters")
    end
 
    it "should redirected to new user session path when not authenticated as a user" do
      delete 'destroy', :id => @character
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
    
    it "should respond forbidden when authenticated as an unauthorized user" do
      some_user_profile = create(:user_profile)
      sign_in some_user_profile.user
      delete 'destroy', :id => @character
      response.should be_forbidden
    end    
  end
end
