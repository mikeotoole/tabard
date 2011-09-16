# require "spec_helper"
# 
# describe AnswersController do
#   describe "routing" do
# 
#     it "routes to #index" do
#       get("submissions/1/answers").should route_to("answers#index", :submission_id => "1")
#     end
# 
#     it "routes to #new" do
#       get("submissions/1/answers/new").should route_to("answers#new", :submission_id => "1")
#     end
# 
#     it "routes to #show" do
#       get("/answers/1").should route_to("answers#show", :id => "1")
#     end
# 
#     it "routes to #create" do
#       post("submissions/1/answers").should route_to("answers#create", :submission_id => "1")
#     end
#     
#     it "routes to #edit" do
#       get("/answers/1/edit").should_not be_routable
#     end
# 
#     it "routes to #update" do
#       put("/answers/1").should_not be_routable
#     end
# 
#     it "routes to #destroy" do
#       delete("/answers/1").should_not be_routable
#     end
# 
#   end
# end
