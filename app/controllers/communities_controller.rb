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
  
  def nav_page_spaces
    @community.page_spaces.all.delete_if {|page_space| !page_space.check_user_show_permissions(current_user)}
  end 
  
  def nav_featured_pages
    @community.pages.featured_pages.alphabetical
  end
end
