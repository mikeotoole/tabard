require "spec_helper"

describe Subdomains::PagesController do
  describe "routing" do
    let(:community) { DefaultObjects.community }
    
    it "routes #index to StatusCodeController#not_found" do
      assert_routing "#{community.subdomain}.example.com/pages", :controller => "status_code", :action => "not_found", :route => "#{community.subdomain}.example.com/pages"
    end
  end
end
