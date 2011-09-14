# require "spec_helper"
# 
# describe TextQuestionsController do
#   describe "routing" do
# 
#     it "routes to #index" do
#       get("/text_questions").should route_to("text_questions#index")
#     end
# 
#     it "routes to #new" do
#       get("/text_questions/new").should route_to("text_questions#new")
#     end
# 
#     it "routes to #show" do
#       get("/text_questions/1").should route_to("text_questions#show", :id => "1")
#     end
# 
#     it "routes to #edit" do
#       get("/text_questions/1/edit").should route_to("text_questions#edit", :id => "1")
#     end
# 
#     it "routes to #create" do
#       post("/text_questions").should route_to("text_questions#create")
#     end
# 
#     it "routes to #update" do
#       put("/text_questions/1").should route_to("text_questions#update", :id => "1")
#     end
# 
#     it "routes to #destroy" do
#       delete("/text_questions/1").should route_to("text_questions#destroy", :id => "1")
#     end
# 
#   end
# end
