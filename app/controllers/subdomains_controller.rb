class SubdomainsController < ApplicationController
  before_filter :find_community_by_subdomain
  skip_before_filter :limit_subdomain_access
  
  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    redirect_to [request.protocol, request.domain, request.port_string].join, :alert => "That community does not exist" and return false unless @community
    false
  end

  def index
  	render :index  
  end
end
