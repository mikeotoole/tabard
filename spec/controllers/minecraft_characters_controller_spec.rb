require 'spec_helper'

describe MinecraftCharactersController do
  let(:valid_attributes) { attributes_for(:minecraft_character) }
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
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should render minecraft_characters/new template" do
      sign_in user
      get 'new'
      response.should render_template('minecraft_characters/new')
    end
  end  
  
  describe "GET 'edit'" do
    before(:each) do
      @character = Factory.create(:minecraft_char_profile)
    end
  
    it "should be successful when authenticated as an authorized user" do
      sign_in user
      get 'edit', :id => @character
      response.should be_success
    end
    
        
    it "should render minecraft_characters/edit template when authenticated as an authorized user" do
      sign_in user
      get 'edit', :id => @character
      response.should render_template('minecraft_characters/edit')
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get 'edit', :id => @character
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
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
    end

    it "should add new character" do
      expect {
        post :create, :minecraft_character => valid_attributes
      }.to change(MinecraftCharacter, :count).by(1)
    end

    it "should pass params to minecraft_character" do
      post :create, :minecraft_character => valid_attributes
      assigns(:minecraft_character).should be_a(MinecraftCharacter)
      assigns(:minecraft_character).should be_persisted
    end

    it "should redirect to user profile characters tab" do
      post :create, :minecraft_character => valid_attributes
      response.should redirect_to(user_profile_url(user.user_profile) + "#characters")
    end
    
    it "should create an activity" do
      expect {
        post :create, :minecraft_character => valid_attributes
      }.to change(Activity, :count).by(1)
      
      activity = Activity.last
      activity.target_type.should eql "CharacterProxy"
      activity.action.should eql 'created'
    end
  end
  
  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      @game = DefaultObjects.minecraft
      post 'create', :minecraft_character => valid_attributes
    end
    
    it "should not create new record" do
      assigns[:minecraft_character].should be_nil
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end   

  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @character = create(:minecraft_char_profile)
      @new_name = 'My new name.'
      sign_in user
      put 'update', :id => @character, :minecraft_character => { :name => @new_name }
    end
  
    it "should change attributes" do
      MinecraftCharacter.find(1).name.should eq(@new_name)
    end
    
    it "should redirect user profile characters tab" do
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
      @character = create(:minecraft_char_profile)
      
      expect {
        put 'update', :id => @character, :minecraft_character => { :name => @character.name }
      }.to change(Activity, :count).by(0)
    end
  end
  
  it "PUT 'update' should respond forbidden when authenticated as an unauthorized user" do
    @character = Factory.create(:minecraft_char_profile)
    some_user_profile = create(:user_profile)
    sign_in some_user_profile.user
    put 'update', :id => @character, :minecraft_character => { :name => "My New Name" }
    response.should be_forbidden
  end
  
  describe "PUT 'update' when not authenticated as a user" do
    before(:each) do
      @character = Factory.create(:minecraft_char_profile)
      put 'update', :id => @character, :minecraft_character => { :name => 'My new name.' }
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end  
    
    it "should not change attributes" do
      assigns[:minecraft_character].should be_nil
    end    
  end 

  describe "DELETE 'destroy'" do
    before(:each) do
      @character = Factory.create(:minecraft_char_profile)
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
