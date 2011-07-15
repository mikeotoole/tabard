class Communities::CommunitiesController < CommunitiesController
  layout 'community'
  before_filter :find_community_by_subdomain, :get_recent_community_items
  # GET /communities/1
  # GET /communities/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @community }
    end
  end
  
  def nav_page_spaces
    @community.page_spaces.all.delete_if {|page_space| !page_space.check_user_show_permissions(current_user)}
  end 
  
  def nav_featured_pages
    @community.pages.featured_pages.alphabetical
  end
  
  def nav_discussions
    @community.discussion_spaces.only_real_ones.delete_if {|discussion_space| (logged_in? and !current_user.can_show(discussion_space)) or !discussion_space.list_in_navigation}   
  end
  
  def get_recent_community_items
    @recent_comments = 
  end
end
