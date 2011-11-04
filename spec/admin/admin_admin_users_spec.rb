# require 'spec_helper'
# 
# describe "Admin::AdminUsersController" do
#   let(:user) { DefaultObjects.user }
# 
#   describe "GET 'index'" do
#     it "should be successful when authenticated as an AdminUser with superuser role" do
#       sign_in user
#       get 'index'
#       response.should be_success
#     end
# 
#     it "should be forbidden when authenticated as a User" do
#       sign_in user
#       get 'index'
#       response.should be_forbidden
#     end
# 
#     it "should be forbidden when not authenticated as a user" do
#       get 'index'
#       response.should be_forbidden
#     end
#   end
# end