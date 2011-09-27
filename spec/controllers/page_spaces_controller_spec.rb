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

describe PageSpacesController do

#   describe "GET index" do
#     it "assigns all page_spaces as @page_spaces" do
#       page_space = PageSpace.create! valid_attributes
#       get :index
#       assigns(:page_spaces).should eq([page_space])
#     end
#   end
# 
#   describe "GET show" do
#     it "assigns the requested page_space as @page_space" do
#       page_space = PageSpace.create! valid_attributes
#       get :show, :id => page_space.id.to_s
#       assigns(:page_space).should eq(page_space)
#     end
#   end
# 
#   describe "GET new" do
#     it "assigns a new page_space as @page_space" do
#       get :new
#       assigns(:page_space).should be_a_new(PageSpace)
#     end
#   end
# 
#   describe "GET edit" do
#     it "assigns the requested page_space as @page_space" do
#       page_space = PageSpace.create! valid_attributes
#       get :edit, :id => page_space.id.to_s
#       assigns(:page_space).should eq(page_space)
#     end
#   end
# 
#   describe "POST create" do
#     describe "with valid params" do
#       it "creates a new PageSpace" do
#         expect {
#           post :create, :page_space => valid_attributes
#         }.to change(PageSpace, :count).by(1)
#       end
# 
#       it "assigns a newly created page_space as @page_space" do
#         post :create, :page_space => valid_attributes
#         assigns(:page_space).should be_a(PageSpace)
#         assigns(:page_space).should be_persisted
#       end
# 
#       it "redirects to the created page_space" do
#         post :create, :page_space => valid_attributes
#         response.should redirect_to(PageSpace.last)
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns a newly created but unsaved page_space as @page_space" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         PageSpace.any_instance.stub(:save).and_return(false)
#         post :create, :page_space => {}
#         assigns(:page_space).should be_a_new(PageSpace)
#       end
# 
#       it "re-renders the 'new' template" do
#         # Trigger the behavior that occurs when invalid params are submitted
#         PageSpace.any_instance.stub(:save).and_return(false)
#         post :create, :page_space => {}
#         response.should render_template("new")
#       end
#     end
#   end
# 
#   describe "PUT update" do
#     describe "with valid params" do
#       it "updates the requested page_space" do
#         page_space = PageSpace.create! valid_attributes
#         # Assuming there are no other page_spaces in the database, this
#         # specifies that the PageSpace created on the previous line
#         # receives the :update_attributes message with whatever params are
#         # submitted in the request.
#         PageSpace.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, :id => page_space.id, :page_space => {'these' => 'params'}
#       end
# 
#       it "assigns the requested page_space as @page_space" do
#         page_space = PageSpace.create! valid_attributes
#         put :update, :id => page_space.id, :page_space => valid_attributes
#         assigns(:page_space).should eq(page_space)
#       end
# 
#       it "redirects to the page_space" do
#         page_space = PageSpace.create! valid_attributes
#         put :update, :id => page_space.id, :page_space => valid_attributes
#         response.should redirect_to(page_space)
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns the page_space as @page_space" do
#         page_space = PageSpace.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         PageSpace.any_instance.stub(:save).and_return(false)
#         put :update, :id => page_space.id.to_s, :page_space => {}
#         assigns(:page_space).should eq(page_space)
#       end
# 
#       it "re-renders the 'edit' template" do
#         page_space = PageSpace.create! valid_attributes
#         # Trigger the behavior that occurs when invalid params are submitted
#         PageSpace.any_instance.stub(:save).and_return(false)
#         put :update, :id => page_space.id.to_s, :page_space => {}
#         response.should render_template("edit")
#       end
#     end
#   end
# 
#   describe "DELETE destroy" do
#     it "destroys the requested page_space" do
#       page_space = PageSpace.create! valid_attributes
#       expect {
#         delete :destroy, :id => page_space.id.to_s
#       }.to change(PageSpace, :count).by(-1)
#     end
# 
#     it "redirects to the page_spaces list" do
#       page_space = PageSpace.create! valid_attributes
#       delete :destroy, :id => page_space.id.to_s
#       response.should redirect_to(page_spaces_url)
#     end
#   end

end
