class CommunitiesController < ApplicationController
  respond_to :html, :xml
  before_filter :find_community_by_subdomain, :only => :show
  before_filter :authenticate, :except => [:show, :index]
  # GET /communities/1
  # GET /communities/1.xml
  
  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    #need to redirect to something if not found
  end
  
  def show
    @community = Community.find(params[:id]) if params[:id]
    render :layout => 'community'
  end
  
  def index
    @communities = Community.all
  end
  
  def new
    @community = Community.new
    if !current_user.can_create(@community)
      render_insufficient_privileges
    else  
      respond_with(@community)
    end
  end
  
  def create
    @community = Community.new(params[:community])
    if !current_user.can_create(@community)
      render_insufficient_privileges
    else  
      if @community.save 
        add_new_flash_message("#{@community.display_name} has been created!")
        current_user.roles << @community.admin_role
      end
      respond_with(@community) 
    end
  end
  
  def edit
    @community = Community.find(params[:id])
    if !current_user.can_update(@community)
      render_insufficient_privileges
    else  
      respond_with(@community)
    end
  end
  
  def update
    @community = Community.find(params[:id])
    if !current_user.can_update(@community)
      render_insufficient_privileges
    else
      @community.update_attributes(params[:community])
      respond_with(@community)
    end
  end
end
