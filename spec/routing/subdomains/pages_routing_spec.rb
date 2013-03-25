require "spec_helper"

describe Subdomains::PagesController do
  describe "routing" do
    let(:community) { DefaultObjects.community }

    it "routes #index to StatusCodeController#not_found" do
      { :get => "#{community.subdomain}.example.com/pages" }.should
        route_to(:controller => :status_code, :action => :not_found, :subdomain => 'www')
    end
  end
end
