# require "spec_helper"
# 
# describe Subdomains::CommentsController do
#   describe "routing" do
#     let(:community) { DefaultObjects.community }
# 
#     it "routes to #index" do
#       get("/comments").should route_to("subdomains/comments#index")
#     end
# 
#     it "routes to #new" do
#       get("/comments/new").should route_to("subdomains/comments#new")
#     end
# 
#     it "routes to #show" do
#       get("/comments/1").should route_to("subdomains/comments#show", :id => "1")
#     end
# 
#     it "routes to #edit" do
#       get("/comments/1/edit").should route_to("subdomains/comments#edit", :id => "1")
#     end
# 
#     it "routes to #create" do
#       post("/comments").should route_to("subdomains/comments#create")
#     end
# 
#     it "routes to #update" do
#       put("/comments/1").should route_to("subdomains/comments#update", :id => "1")
#     end
# 
#     it "routes to #destroy" do
#       delete("/comments/1").should route_to("subdomains/comments#destroy", :id => "1")
#     end
# 
#   end
# end
