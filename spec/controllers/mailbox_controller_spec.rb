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

describe MailboxController do
  let(:message) { create(:message) }
  let(:sender) { DefaultObjects.user }
  let(:receiver) { DefaultObjects.additional_community_user_profile.user }

  describe "GET inbox" do
    it "assigns all messages inbox folder as @messages when authenticated as user" do
      message
      sign_in receiver
      get :inbox
      assigns(:messages).should eq([message.message_associations.first])
    end
    
    it "assigns inbox folder as @folder when authenticated as user" do
      message
      sign_in receiver
      get :inbox
      assigns(:folder).should eq(receiver.inbox)
    end
    
    it "should render the 'show' template when authenticated as user" do
      sign_in receiver
      get :inbox
      response.should render_template("show")
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :inbox
      response.should redirect_to(new_user_session_path)
    end
  end

  describe "GET trash" do
    it "assigns all messages in trash folder as @messages when authenticated as user" do
      message_association = message.message_associations.first
      message_association.should be_a(MessageAssociation)
      message_association.folder = receiver.trash
      message_association.save.should be_true
      message_association.folder.name.should eq("Trash")
      sign_in receiver
      get :trash
      assigns(:messages).should eq([message_association])
    end
    
    it "assigns trash folder as @folder when authenticated as user" do
      message
      sign_in receiver
      get :trash
      assigns(:folder).should eq(receiver.trash)
    end
    
    it "should render the 'show' template when authenticated as user" do
      sign_in receiver
      get :trash
      response.should render_template("show")
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      get :trash
      response.should redirect_to(new_user_session_path)
    end
  end

end
