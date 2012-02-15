require "spec_helper"

describe Subdomains::CommunitiesController do
  describe "routing" do
    let(:community) { DefaultObjects.community }
    
#     it "routes get #community_settings to CommunitiesController#edit" do
#       assert_routing { :method => 'get', :path => "/community_settings" },
#                      { :controller => "communities", :action => "edit", 
#                         :route => "#{community.subdomain}.lvh.me/community_settings" }
#     end
    
#     it "routes put #community_settings to CommunitiesController#update" do
#       Subdomains::CommunitiesController.stub!(:find_community_by_subdomain).and_return(true)
#       put("/community_settings").should route_to(
#                         :controller => "communities", 
#                         :action => "update", 
#                         :route => "#{community.subdomain}.example.com/community_settings")
#     end
    
    it "routes #index to StatusCodeController#not_found" do
      assert_routing "#{community.subdomain}.example.com/communities", 
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/communities"
    end
    
    it "routes #new to StatusCodeController#not_found" do
      assert_routing "#{community.subdomain}.example.com/communities/new", 
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/communities/new"
    end
    
    it "routes #show to StatusCodeController#not_found" do
      assert_routing "#{community.subdomain}.example.com/communities/#{community.id}", 
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/communities/#{community.id}"
    end
    
    it "routes #create to StatusCodeController#not_found" do
      post("#{community.subdomain}.example.com/communities").should route_to(
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/communities")
    end
    
    it "routes #destroy to StatusCodeController#not_found" do
      delete("#{community.subdomain}.example.com/communities").should route_to(
                        :controller => "status_code", 
                        :action => "not_found", 
                        :route => "#{community.subdomain}.example.com/communities")
    end
  end
end
