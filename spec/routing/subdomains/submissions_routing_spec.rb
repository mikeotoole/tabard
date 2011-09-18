# require "spec_helper"
# 
# describe Subdomains::SubmissionsController do
#   describe "routing" do
# 
#     it "routes to #index" do
#       get("/custom_forms/1/submissions").should route_to("submissions#index", :custom_form_id => "1")
#     end
# 
#     it "routes to #new" do
#       get("/custom_forms/1/submissions/new").should route_to("submissions#new", :custom_form_id => "1")
#     end
# 
#     it "routes to #show" do
#       get("/custom_forms/1/submissions/1").should route_to("submissions#show", :id => "1", :custom_form_id => "1")
#     end
# 
#     it "routes to #edit" do
#       get("/submissions/1/edit").should_not be_routable
#     end
# 
#     it "routes to #create" do
#       post("/custom_forms/1/submissions").should route_to("submissions#create", :custom_form_id => "1")
#     end
# 
#     it "routes to #update" do
#       put("/submissions/1").should_not be_routable
#     end
# 
#     it "routes to #destroy" do
#       delete("/submissions/1").should route_to("submissions#destroy", :id => "1", :custom_form_id => "1")
#     end
# 
#   end
# end
