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

describe SentMessagesController do
  let(:message) { create(:message) }
  let(:rec_message) { message.message_associations.first }
  let(:sender) { DefaultObjects.user }
  let(:receiver) { DefaultObjects.additional_community_user_profile.user }

  describe "GET index" do
    it "assigns all users sent_messages as @messages when authenticated as a user" do
      message
      sign_in sender
      get :index
      assigns(:messages).should eq([message])
    end

    it "should render the 'index' template when authenticated as a user" do
      sign_in sender
      get :index
      response.should render_template("index")
    end

    it "should redirected to new user session path when not authenticated as a user" do
      get :index
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "GET show" do
    it "assigns the requested message as @message when authenticated as owner" do
      sign_in sender
      get :show, :id => message
      assigns(:message).should eq(message)
    end

    it "should render the 'show' template when authenticated as a owner" do
      sign_in sender
      get :show, :id => message
      response.should render_template("show")
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :show, :id => message
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end

    it "should raise error when authenticated as not the owner" do
      sign_in receiver
      lambda { get :show, :id => message }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET new" do
    it "assigns a new message as @message when authenticated as user" do
      sign_in sender
      get :new
      assigns(:message).should be_a_new(Message)
    end

    it "should render the 'new' template when authenticated as community admin" do
      sign_in sender
      get :new
      response.should render_template("new")
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :new
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

  describe "POST create when authenticated as admin" do
    before(:each) {
      sign_in sender
    }

    describe "with valid params" do
      it "creates a new Message" do
        receiver
        some_attr  = attributes_for(:message)
        expect {
          post :create, :message => some_attr
        }.to change(Message, :count).by(1)
      end

      it "assigns a newly created message as @message" do
        post :create, :message => attributes_for(:message)
        assigns(:message).should be_a(Message)
        assigns(:message).should be_persisted
      end

      it "redirects to the users sent_mailbox" do
        post :create, :message => attributes_for(:message)
        response.should redirect_to(inbox_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved message as @message" do
        post :create, :message => attributes_for(:message, :body => nil)
        assigns(:message).should be_a_new(Message)
      end

      it "re-renders the 'new' template" do
        post :create, :message => attributes_for(:message, :body => nil)
        response.should render_template("new")
      end
    end
  end

  describe "POST create" do
    it "should redirected to new user session path when not authenticated as a user" do
      post :create, :message => attributes_for(:message)
      response.should redirect_to(new_user_session_url(subdomain: 'secure', protocol: "https://"))
    end
  end

end
