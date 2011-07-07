class CommunitiesController < ApplicationController
  layout 'community'
  before_filter :find_community_by_subdomain
  # GET /communities/1
  # GET /communities/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @community }
    end
  end

  
  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    #need to redirect to something if not found
  end
    
end
