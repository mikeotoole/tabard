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

describe Subdomains::CommentsController do
  let(:user) { DefaultObjects.user }
  let(:admin) { DefaultObjects.community_admin }
  let(:non_member) { create(:user_profile).user }
  let(:community) { DefaultObjects.community }
  let(:comment) { create(:comment) }
  let(:discussion) { create(:discussion) }

  before(:each) do
    @request.host = "#{community.subdomain}.example.com"
  end

  describe "GET new" do
    it "assigns a new comment as @comment when authenticated as a user with permissions" do
      sign_in user
      get :new, :comment => { :commentable_id => discussion.id, :commentable_type => discussion.class }
      assigns(:comment).should be_a_new(Comment)
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :new, :comment => { :commentable_id => discussion.id, :commentable_type => discussion.class }
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :new, :comment => { :commentable_id => discussion.id, :commentable_type => discussion.class }
      response.should be_forbidden
    end
  end

  describe "GET edit" do
    it "assigns the requested comment as @comment when authenticated as a user with permissions" do
      sign_in user
      get :edit, :id => comment.id.to_s
      assigns(:comment).should eq(comment)
    end

    it "should redirect to new user session path when not authenticated as a user" do
      get :edit, :id => comment.id.to_s
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      get :edit, :id => comment.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST create when authenticated as a user with permissions" do
    before(:each) {
      sign_in user
    }

    describe "with valid params" do
      it "creates a new Comment" do
        expect {
          post :create, :comment => attributes_for(:comment)
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, :comment => attributes_for(:comment)
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end

      it "redirects to the created comment" do
        post :create, :comment => attributes_for(:comment)
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        post :create, :comment => {}
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        post :create, :comment => attributes_for(:comment, :body => nil)
        response.body.should == ""
      end
    end
  end

  describe "POST create" do
    it "should redirected to new user session path when not authenticated as a user" do
      post :create, :comment => attributes_for(:comment)
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :create, :comment => attributes_for(:comment)
      response.should be_forbidden
    end
  end

  describe "PUT update when authenticated as a user with permissions" do
    before(:each) {
      sign_in user
    }

    describe "with valid params" do
      it "updates the requested comment" do
        comment
        # Assuming there are no other comments in the database, this
        # specifies that the Comment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Comment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => comment.id, :comment => {'these' => 'params'}
      end

      it "assigns the requested comment as @comment" do
        put :update, :id => comment.id, :comment => attributes_for(:comment)
        assigns(:comment).should eq(comment)
      end

      it "redirects to the comment" do
        put :update, :id => comment.id, :comment => attributes_for(:comment)
        response.should be_success
      end
    end

    describe "with invalid params" do
      it "assigns the comment as @comment" do
        put :update, :id => comment.id.to_s, :comment => {:body => nil}
        assigns(:comment).should eq(comment)
      end

      it "re-renders the 'edit' template" do
        put :update, :id => comment.id.to_s, :comment => {:body => nil}
        response.should render_template("_comment")
      end
    end
  end

  describe "PUT update" do
    it "should redirect to new user session path when not authenticated as a user" do
      put :update, :id => comment.id, :comment => attributes_for(:comment)
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      put :update, :id => comment.id, :comment => attributes_for(:comment)
      response.should be_forbidden
    end
  end

  describe "DELETE destroy when authenticated as a user with permissions" do
    it "does not destroy the requested comment if comment has subcomments" do
      comment.comments << create(:comment, :commentable_type => "Comment", :commentable_id => comment.id)
      comment.comments.should_not be_empty
      sign_in user
      expect {
        delete :destroy, :id => comment.id.to_s
      }.to change(Comment, :count).by(0)
    end

    it "does destroy the requested comment if it has no subcomments" do
      comment.comments.should be_empty
      sign_in user
      expect {
        delete :destroy, :id => comment.id.to_s
      }.to change(Comment, :count).by(-1)
    end

    it "redirects to the original comment item if comment has subcomments" do
      comment.comments << create(:comment, :commentable_type => "Comment", :commentable_id => comment.id)
      comment.comments.should_not be_empty
      sign_in user
      delete :destroy, :id => comment.id.to_s
      response.should be_success
    end

    it "redirects to the original comment item if comment has no subcomments" do
      comment.comments.should be_empty
      sign_in user
      delete :destroy, :id => comment.id.to_s
      response.should be_success
    end

    it "sets comment is_removed to true if comment has subcomments" do
      comment.comments << create(:comment, :commentable_type => "Comment", :commentable_id => comment.id)
      comment.comments.should_not be_empty
      sign_in user
      delete :destroy, :id => comment.id.to_s
      Comment.find(comment).is_removed.should be_true
    end

    it "should be forbidden if comment is locked" do
      comment.is_locked = true
      comment.save.should be_true
      sign_in user
      delete :destroy, :id => comment.id.to_s
      response.should be_forbidden
    end
  end

  describe "DELETE destroy" do
    it "should redirect to new user session path when not authenticated as a user" do
      delete :destroy, :id => comment.id.to_s
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      delete :destroy, :id => comment.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST lock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
    }

    it "should lock the comment when authenticated as community admin" do
      sign_in admin
      post :lock, :id => comment.id.to_s
      Comment.find(comment).is_locked.should be_true
    end

    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :lock, :id => comment.id.to_s
      response.should be_success
    end

    it "should not lock the comment when authenticated as a user" do
      sign_in user
      post :lock, :id => comment.id.to_s
      Comment.find(comment).is_locked.should be_false
    end

    it "should not lock the comment when not authenticated as a user" do
      post :lock, :id => comment.id.to_s
      Comment.find(comment).is_locked.should be_false
    end

    it "should redirect to new user session path when not authenticated as a user" do
      post :lock, :id => comment.id.to_s
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :lock, :id => comment.id.to_s
      response.should be_forbidden
    end
  end

  describe "POST unlock" do
    before(:each) {
      request.env["HTTP_REFERER"] = "/"
      comment.is_locked = true
      comment.save!
    }

    it "should unlock the comment when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => comment.id.to_s
      Comment.find(comment).is_locked.should be_false
    end

    it "should redirect back when authenticated as community admin" do
      sign_in admin
      post :unlock, :id => comment.id.to_s
      response.should be_success
    end

    it "should not unlock the comment when authenticated as a user" do
      sign_in user
      Comment.find(comment).is_locked.should be_true
      post :unlock, :id => comment.id.to_s
      Comment.find(comment).is_locked.should be_true
    end

    it "should not unlock the comment when not authenticated as a user" do
      post :unlock, :id => comment.id.to_s
      Comment.find(comment).is_locked.should be_true
    end

    it "should redirect to new user session path when not authenticated as a user" do
      post :unlock, :id => comment.id.to_s
      response.should redirect_to(new_user_session_url)
    end

    it "should respond forbidden when not a member" do
      sign_in non_member
      post :unlock, :id => comment.id.to_s
      response.should be_forbidden
    end
  end
end
