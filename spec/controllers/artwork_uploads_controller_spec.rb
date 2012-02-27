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

describe ArtworkUploadsController do
  let(:valid_attributes) { attributes_for(:artwork_upload_att) }

  describe "GET new" do
    it "assigns a new artwork_upload as @artwork_upload" do
      get :new
      assigns(:artwork_upload).should be_a_new(ArtworkUpload)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ArtworkUpload" do
        expect {
          post :create, :artwork_upload => valid_attributes
        }.to change(ArtworkUpload, :count).by(1)
      end

      it "assigns a newly created artwork_upload as @artwork_upload" do
        post :create, :artwork_upload => valid_attributes
        assigns(:artwork_upload).should be_a(ArtworkUpload)
        assigns(:artwork_upload).should be_persisted
      end

      it "redirects to root_url" do
        post :create, :artwork_upload => valid_attributes
        response.should redirect_to(root_url)
      end
    end

    describe "with invalid params" do    
      it "assigns a newly created but unsaved artwork_upload as @artwork_upload" do
        post :create, :artwork_upload => attributes_for(:artwork_upload_att, :email => nil)
        assigns(:artwork_upload).should be_a_new(ArtworkUpload)
      end

      it "re-renders the 'new' template" do
        post :create, :artwork_upload => attributes_for(:artwork_upload_att, :email => nil)
        response.should render_template(:new)
      end
    end
  end
end
