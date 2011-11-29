require 'spec_helper'

describe WowCharactersController do
  let(:valid_attributes) { attributes_for(:wow_character_att, :name => "My Test Name") }
  let(:user) { DefaultObjects.user }
  
  describe "GET 'show'" do
    before(:each) do
      @character = Factory.create(:wow_char_profile)
    end
    
    it "should be successful when authenticated as a user" do
      sign_in user
      get 'show', :id => @character
      response.should be_success
    end
  
    it "should be successful when not authenticated as a user" do
      get 'show', :id => @character
      response.should be_success
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
      response.should redirect_to(new_user_session_path)
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
      @game = DefaultObjects.wow
      post 'create', :wow_character => valid_attributes
    end
    
    it "should add new character" do
      WowCharacter.exists?(1).should be_true
    end
    
    it "should pass params to wow_character" do
      WowCharacter.find(1).name.should == "My Test Name"
    end
    
    it "should redirect to new wow character" do
      response.should redirect_to(wow_character_path(1))
    end
  end
  
  describe "POST 'create' when not authenticated as a user" do
    before(:each) do
      @game = Wow.new(:name => "My Wow")
      post 'create', :wow_character => valid_attributes
    end
    
    it "should not create new record" do
      assigns[:wow_character].should be_nil
    end
    
    it "should redirect to new user session path" do
      response.should redirect_to(new_user_session_path)
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
    
    it "should redirect to wow character" do
      response.should redirect_to(wow_character_path(assigns[:swtor_character]))
    end
  end
  
  describe "PUT 'update' when authenticated as a user" do
    before(:each) do
      @characterDefault = Factory.create(:wow_char_profile)
      @characterNotDefault = Factory.create(:wow_char_profile)
      sign_in user
    end
  
    it "should update default when set to true" do
      @characterNotDefault.default.should be_false
      put 'update', :id => @characterNotDefault, :wow_character => { :default => true }
      WowCharacter.exists?(@characterNotDefault).should be_true
      WowCharacter.find(@characterNotDefault).default.should be_true
    end
    
    it "should not update default when set from true to false" do
      @characterDefault.default.should be_true
      put 'update', :id => @characterDefault, :wow_character => { :default => false }
      WowCharacter.exists?(@characterDefault).should be_true
      WowCharacter.find(@characterDefault).default.should be_true
    end
    
    it "should not make character default on update" do
      @characterNotDefault.default.should be_false
      put 'update', :id => @characterNotDefault, :wow_character => { :name => "New Name" }
      WowCharacter.exists?(@characterNotDefault).should be_true
      WowCharacter.find(@characterNotDefault).default.should be_false
      WowCharacter.find(@characterNotDefault).name.should eql "New Name"
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
      response.should redirect_to(new_user_session_path)
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
      response.should redirect_to(wow_characters_path)
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
