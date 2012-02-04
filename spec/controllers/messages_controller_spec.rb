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

describe MessagesController do
  let(:message) { create(:message) }
  let(:rec_message) { message.message_associations.first }
  let(:rec_message_2) { create(:message).message_associations.first }
  let(:rec_message_id_array) { [[rec_message.id], [rec_message_2.id]] }
  let(:sender) { DefaultObjects.user }
  let(:receiver) { DefaultObjects.additional_community_user_profile.user }
  let(:other_user) { create(:user_profile).user }

  describe "GET show" do
    it "assigns the requested message as @message when authenticated as owner" do
      sign_in receiver
      get :show, :id => rec_message
      assigns(:message).should eq(rec_message)
    end
    
    it "should render the 'show' template when authenticated as owner" do
      sign_in receiver
      get :show, :id => rec_message
      response.should render_template("show")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :show, :id => rec_message
      response.should redirect_to(new_user_session_url)
    end
    
    it "should raise error when authenticated as not the owner" do
      sign_in sender
      lambda { get :show, :id => rec_message }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe "POST mark_read" do
    it "assigns the requested message as @message when authenticated as owner" do
      sign_in receiver
      post :mark_read, :id => rec_message, :return_url => inbox_url
      assigns(:message).should eq(rec_message)
    end
    
    it "should mark message as read when authenticated as owner" do
      sign_in receiver
      rec_message.has_been_read.should be_false
      post :mark_read, :id => rec_message, :return_url => inbox_url
      assigns(:message).has_been_read.should be_true
    end
    
    it "redirects to the return_url when authenticated as owner" do
      sign_in receiver
      post :mark_read, :id => rec_message, :return_url => user_profile_path(receiver.user_profile)
      response.should redirect_to(user_profile_path(receiver.user_profile))
    end
    
    it "should raise error when authenticated as not the owner" do
      sign_in sender
      lambda { get :show, :id => rec_message, :return_url => inbox_url }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe "POST mark_unread" do
    it "assigns the requested message as @message when authenticated as owner" do
      sign_in receiver
      post :mark_unread, :id => rec_message, :return_url => inbox_url
      assigns(:message).should eq(rec_message)
    end
    
    it "should mark message as read when authenticated as owner" do
      sign_in receiver
      rec_message.has_been_read = true
      rec_message.save.should be_true
      post :mark_unread, :id => rec_message, :return_url => inbox_url
      assigns(:message).has_been_read.should be_false
    end
    
    it "redirects to the return_url when authenticated as owner" do
      sign_in receiver
      post :mark_unread, :id => rec_message, :return_url => user_profile_path(receiver.user_profile)
      response.should redirect_to(user_profile_path(receiver.user_profile))
    end
    
    it "should raise error when authenticated as not the owner" do
      sign_in sender
      lambda { get :show, :id => rec_message, :return_url => inbox_url }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe "PUT move when authenticated as owner" do
    before(:each) {
      sign_in receiver
      request.env["HTTP_REFERER"] = "/"
    }
  
    it "moves the requested message" do
      rec_message
      MessageAssociation.any_instance.should_receive(:update_attributes).with({:folder_id => receiver.trash.id, :has_been_read => true})
      put :move, :id => rec_message.id, :folder_id => receiver.trash
    end

    it "assigns the requested message as @message" do
      put :move, :id => rec_message.id, :folder_id => receiver.trash
      assigns(:message).should eq(rec_message)
    end

    it "redirects to the return_url" do
      put :move, :id => rec_message.id, :folder_id => receiver.trash, :return_url => user_profile_path(receiver.user_profile)
      response.should redirect_to(user_profile_path(receiver.user_profile))
    end

    describe "with invalid folder" do
      it "assigns the message as @message" do
        put :move, :id => rec_message.id, :folder_id => 0
        assigns(:message).should eq(nil)
      end
    
      it "should respond forbidden" do
        put :move, :id => rec_message.id, :folder_id => 0
        response.should be_forbidden
      end
    end
    
    describe "with invalid message" do
      it "assigns the message as @message" do
        put :move, :id => 0, :folder_id => receiver.trash
        assigns(:message).should eq(nil)
      end
    
      it "should respond forbidden" do
        put :move, :id => 0, :folder_id => receiver.trash
        response.should be_forbidden
      end
    end
  end

  describe "PUT move" do
    it "should redirected to new user session path when not authenticated as a user" do
      put :move, :id => rec_message.id, :folder_id => receiver.trash
      response.should redirect_to(new_user_session_url)
    end
    
    it "should respond forbidden when not owner" do
      sign_in sender
      put :move, :id => rec_message.id, :folder_id => receiver.trash
      response.should be_forbidden
    end 
  end

  describe "PUT batch_move" do
    it "moves all requested messages" do
      sign_in receiver     
      rec_message.folder.should_not eq(receiver.trash)
      rec_message_2.folder.should_not eq(receiver.trash)
      put :batch_move, :ids => rec_message_id_array, :folder_id => receiver.trash
      MessageAssociation.find(rec_message).folder.should eq(receiver.trash)
      MessageAssociation.find(rec_message_2).folder.should eq(receiver.trash)
    end

    it "redirects to the inbox_url" do
      sign_in receiver
      put :batch_move, :ids => rec_message_id_array, :folder_id => receiver.trash
      response.should redirect_to(inbox_url)      
    end

    describe "with invalid folder" do    
      it "should respond forbidden" do
        sign_in receiver
        put :batch_move, :ids => rec_message_id_array, :folder_id => 0
        response.should be_forbidden
      end
    end
    
    describe "with invalid message" do
      it "should respond forbidden" do
        sign_in receiver
        put :batch_move, :ids => [[0]], :folder_id => receiver.trash
        response.should be_forbidden
      end
    end
  end

  describe "PUT batch_mark_read" do
    it "marks all requested messages as read" do
      sign_in receiver     
      rec_message.folder.should_not eq(receiver.trash)
      rec_message_2.folder.should_not eq(receiver.trash)
      rec_message_id_array.each do |id|
        MessageAssociation.find_by_id(id).update_attribute(:has_been_read, false)
      end
      rec_message_id_array.each do |id|
        MessageAssociation.find_by_id(id).has_been_read.should be_false
      end
      put :batch_mark_read, :ids => rec_message_id_array
      rec_message_id_array.each do |id|
        MessageAssociation.find_by_id(id).has_been_read.should be_true
      end
    end

    it "redirects to the inbox_url" do
      sign_in receiver
      put :batch_mark_read, :ids => rec_message_id_array
      response.should redirect_to(inbox_url)      
    end
    
    describe "with invalid message" do
      it "should respond forbidden" do
        sign_in receiver
        put :batch_mark_read, :ids => [[0]]
        response.should be_forbidden
      end
    end
  end

  describe "PUT batch_mark_unread" do
    it "marks all requested messages as unread" do
      sign_in receiver     
      rec_message.folder.should_not eq(receiver.trash)
      rec_message_2.folder.should_not eq(receiver.trash)
      rec_message_id_array.each do |id|
        MessageAssociation.find_by_id(id).update_attribute(:has_been_read, true)
      end
      rec_message_id_array.each do |id|
        MessageAssociation.find_by_id(id).has_been_read.should be_true
      end
      put :batch_mark_unread, :ids => rec_message_id_array
      rec_message_id_array.each do |id|
        MessageAssociation.find_by_id(id).has_been_read.should be_false
      end
    end

    it "redirects to the inbox_url" do
      sign_in receiver
      put :batch_mark_unread, :ids => rec_message_id_array
      response.should redirect_to(inbox_url)      
    end
    
    describe "with invalid message" do
      it "should respond forbidden" do
        sign_in receiver
        put :batch_mark_unread, :ids => [[0]]
        response.should be_forbidden
      end
    end
  end

  describe "GET reply" do
    it "assigns the requested message as @original when authenticated as owner" do
      sign_in receiver
      get :reply, :id => rec_message.message_id
      assigns(:original).should eq(rec_message)
    end
    
    it "assigns a new message as @message when authenticated as owner" do
      sign_in receiver
      get :reply, :id => rec_message.message_id
      assigns(:message).should be_new_record
    end
    
    it "@message author is set to the receiver when authenticated as owner" do
      sign_in receiver
      get :reply, :id => rec_message.message_id
      assigns(:message).author.should eq(receiver.user_profile)
    end
    
    it "@message to is set to the author when authenticated as owner" do
      sign_in receiver
      get :reply, :id => rec_message.message_id
      assigns(:message).to.should eq(["#{rec_message.author.id}"])
    end
    
    it "should render the 'show' template when authenticated as owner" do
      sign_in receiver
      get :reply, :id => rec_message.message_id
      response.should render_template("sent_messages/new")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :reply, :id => rec_message.message_id
      response.should redirect_to(new_user_session_url)
    end
    
    it "should redirect to inbox when not authenticated" do
      sign_in sender
      get :reply, :id => rec_message.message_id
      response.should redirect_to(inbox_url)
    end
  end

  describe "GET reply_all" do
    it "assigns the requested message as @original when authenticated as owner" do
      sign_in receiver
      multi_mess = create(:message_with_muti_to).message_associations.last
      get :reply_all, :id => multi_mess
      assigns(:original).should eq(multi_mess)
    end
    
    it "assigns a new message as @message when authenticated as owner" do
      sign_in receiver
      get :reply_all, :id => create(:message_with_muti_to).message_associations.last.message_id
      assigns(:message).should be_new_record
    end
    
    it "@message author is set to the receiver when authenticated as owner" do
      sign_in receiver
      get :reply_all, :id => create(:message_with_muti_to).message_associations.last.message_id
      assigns(:message).author.should eq(receiver.user_profile)
    end
    
    it "@message to is set to the author and all @original recipients when authenticated as owner" do
      message = create(:message_with_muti_to)
      mess_id = message.message_associations.last.message_id
      receiver = message.message_associations.last.recipient.user
      message.message_associations.count.should eq 2
      sign_in receiver
      get :reply_all, :id => mess_id
      assigns(:message).to.should eq(["#{message.message_associations.first.recipient.id}", "#{message.author.id}"])
    end
    
    it "should render the 'show' template when authenticated as owner" do
      sign_in receiver
      get :reply_all, :id => create(:message_with_muti_to).message_associations.last.message_id
      response.should render_template("sent_messages/new")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :reply_all, :id => create(:message_with_muti_to).message_associations.first.message_id
      response.should redirect_to(new_user_session_url)
    end
    
    it "should redirect to inbox when not authenticated" do
      sign_in sender
      get :reply_all, :id => create(:message_with_muti_to).message_associations.first.message_id
      response.should redirect_to(inbox_url)
    end  
  end

  describe "GET forward" do
    it "assigns the requested message as @original when authenticated as owner" do
      sign_in receiver
      get :forward, :id => rec_message.message_id
      assigns(:original).should eq(rec_message)
    end
    
    it "assigns a new message as @message when authenticated as owner" do
      sign_in receiver
      get :forward, :id => rec_message.message_id
      assigns(:message).should be_new_record
    end
    
    it "@message author is set to the receiver when authenticated as owner" do
      sign_in receiver
      get :forward, :id => rec_message.message_id
      assigns(:message).author.should eq(receiver.user_profile)
    end
    
    it "@message to is set to -1 when authenticated as owner" do
      sign_in receiver
      get :forward, :id => rec_message.message_id
      assigns(:message).to.should eq([-1])
    end
    
    it "should render the 'show' template when authenticated as owner" do
      sign_in receiver
      get :forward, :id => rec_message.message_id
      response.should render_template("sent_messages/new")
    end
    
    it "should redirect to new user session path when not authenticated as a user" do
      get :forward, :id => rec_message.message_id
      response.should redirect_to(new_user_session_url)
    end
    
    it "should redirect to inbox when not authenticated" do
      sign_in other_user
      get :forward, :id => rec_message.message_id
      response.should redirect_to(inbox_url)
    end 
  end

  describe "DELETE destroy" do
    it "sets the requested message as is_removed when authenticated as a owner" do
      sign_in receiver
      delete :destroy, :id => rec_message
      MessageAssociation.find(rec_message).is_removed.should be_true
    end
    
    it "sets the requested message folder to nil when authenticated as a owner" do
      sign_in receiver
      delete :destroy, :id => rec_message
      MessageAssociation.find(rec_message).folder.should be_nil
    end
    
    it "does not destroy the requested message when authenticated as a owner" do
      rec_message
      sign_in receiver
      expect {
        delete :destroy, :id => rec_message
      }.to change(MessageAssociation, :count).by(0)
    end    

    it "redirects to the trash folder when authenticated as a owner" do
      sign_in receiver
      delete :destroy, :id => rec_message
      response.should redirect_to(trash_url)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      delete :destroy, :id => rec_message
      response.should redirect_to(new_user_session_url)
    end
    
    it "should raise error when authenticated as not the owner" do
      sign_in sender
      lambda { delete :destroy, :id => rec_message }.should raise_error(ActiveRecord::RecordNotFound)
    end  
  
    it "should set all messages in trash folder as is_removed when no message is given and authenticated as a owner" do
      message_two = create(:message).message_associations.first
      message_two.folder = receiver.user_profile.trash
      message_two.save.should be_true
      rec_message.folder = receiver.user_profile.trash
      rec_message.save.should be_true
      sign_in receiver
      delete :destroy
      MessageAssociation.find(message_two).is_removed.should be_true
      MessageAssociation.find(rec_message).is_removed.should be_true
    end
    
    it "should set all messages in trash folder folder to nil when no message is given and authenticated as a owner" do
      message_two = create(:message).message_associations.first
      message_two.folder = receiver.user_profile.trash
      message_two.save.should be_true
      rec_message.folder = receiver.user_profile.trash
      rec_message.save.should be_true
      sign_in receiver
      delete :destroy
      MessageAssociation.find(message_two).folder.should be_nil
      MessageAssociation.find(rec_message).folder.should be_nil
    end
  
    it "redirects to the inbox folder when no message is given and authenticated as a owner" do
      sign_in receiver
      delete :destroy
      response.should redirect_to(inbox_url)
    end
  
  end
  
  describe "DELETE batch_destroy" do
    it "sets all requested messages as is_removed when authenticated as a owner" do
      sign_in receiver
      delete :batch_destroy, :ids => rec_message_id_array
      MessageAssociation.find(rec_message).is_removed.should be_true
      MessageAssociation.find(rec_message_2).is_removed.should be_true
    end
    
    it "sets all requested messages folders to nil when authenticated as a owner" do
      sign_in receiver
      delete :batch_destroy, :ids => rec_message_id_array
      MessageAssociation.find(rec_message).folder.should be_nil
      MessageAssociation.find(rec_message_2).folder.should be_nil
    end
    
    it "does not destroy the requested messages when authenticated as a owner" do
      rec_message
      rec_message_2
      sign_in receiver
      expect {
        delete :batch_destroy, :ids => rec_message_id_array
      }.to change(MessageAssociation, :count).by(0)
    end    

    it "redirects to the trash folder when authenticated as a owner" do
      sign_in receiver
      delete :batch_destroy, :ids => rec_message_id_array
      response.should redirect_to(trash_url)
    end
    
    it "should redirected to new user session path when not authenticated as a user" do
      delete :batch_destroy, :ids => rec_message_id_array
      response.should redirect_to(new_user_session_url)
    end
    
    it "should responded forbidden when authenticated as not the owner" do
      sign_in sender
      delete :batch_destroy, :ids => rec_message_id_array
      response.should be_forbidden
    end 
  end
  
end
