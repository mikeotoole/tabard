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

describe CustomFormsController do

  # This should return the minimal set of attributes required to create a valid
  # CustomForm. As you add validations to CustomForm, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all custom_forms as @custom_forms" do
      custom_form = CustomForm.create! valid_attributes
      get :index
      assigns(:custom_forms).should eq([custom_form])
    end
  end

  describe "GET show" do
    it "assigns the requested custom_form as @custom_form" do
      custom_form = CustomForm.create! valid_attributes
      get :show, :id => custom_form.id.to_s
      assigns(:custom_form).should eq(custom_form)
    end
  end

  describe "GET new" do
    it "assigns a new custom_form as @custom_form" do
      get :new
      assigns(:custom_form).should be_a_new(CustomForm)
    end
  end

  describe "GET edit" do
    it "assigns the requested custom_form as @custom_form" do
      custom_form = CustomForm.create! valid_attributes
      get :edit, :id => custom_form.id.to_s
      assigns(:custom_form).should eq(custom_form)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new CustomForm" do
        expect {
          post :create, :custom_form => valid_attributes
        }.to change(CustomForm, :count).by(1)
      end

      it "assigns a newly created custom_form as @custom_form" do
        post :create, :custom_form => valid_attributes
        assigns(:custom_form).should be_a(CustomForm)
        assigns(:custom_form).should be_persisted
      end

      it "redirects to the created custom_form" do
        post :create, :custom_form => valid_attributes
        response.should redirect_to(CustomForm.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved custom_form as @custom_form" do
        # Trigger the behavior that occurs when invalid params are submitted
        CustomForm.any_instance.stub(:save).and_return(false)
        post :create, :custom_form => {}
        assigns(:custom_form).should be_a_new(CustomForm)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        CustomForm.any_instance.stub(:save).and_return(false)
        post :create, :custom_form => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested custom_form" do
        custom_form = CustomForm.create! valid_attributes
        # Assuming there are no other custom_forms in the database, this
        # specifies that the CustomForm created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        CustomForm.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => custom_form.id, :custom_form => {'these' => 'params'}
      end

      it "assigns the requested custom_form as @custom_form" do
        custom_form = CustomForm.create! valid_attributes
        put :update, :id => custom_form.id, :custom_form => valid_attributes
        assigns(:custom_form).should eq(custom_form)
      end

      it "redirects to the custom_form" do
        custom_form = CustomForm.create! valid_attributes
        put :update, :id => custom_form.id, :custom_form => valid_attributes
        response.should redirect_to(custom_form)
      end
    end

    describe "with invalid params" do
      it "assigns the custom_form as @custom_form" do
        custom_form = CustomForm.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CustomForm.any_instance.stub(:save).and_return(false)
        put :update, :id => custom_form.id.to_s, :custom_form => {}
        assigns(:custom_form).should eq(custom_form)
      end

      it "re-renders the 'edit' template" do
        custom_form = CustomForm.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        CustomForm.any_instance.stub(:save).and_return(false)
        put :update, :id => custom_form.id.to_s, :custom_form => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested custom_form" do
      custom_form = CustomForm.create! valid_attributes
      expect {
        delete :destroy, :id => custom_form.id.to_s
      }.to change(CustomForm, :count).by(-1)
    end

    it "redirects to the custom_forms list" do
      custom_form = CustomForm.create! valid_attributes
      delete :destroy, :id => custom_form.id.to_s
      response.should redirect_to(custom_forms_url)
    end
  end

end
