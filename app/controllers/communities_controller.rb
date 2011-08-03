=begin
  Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
  Copyright:: Copyright (c) 2011 DigitalAugment Inc.
  License::   Proprietary Closed Source
  
  This controller is for communities.
=end
class CommunitiesController < ApplicationController
  respond_to :html
  before_filter :find_community_by_subdomain, :only => :show
  before_filter :authenticate, :except => [:show, :index]
  
  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    #logger.debug("Unable to find #{request.subdomain.downcase} => #{root_url(:subdomain => false)}") unless @community
    redirect_to [request.protocol, request.domain, request.port_string].join, :alert => "That community does not exist" and return false unless @community
  end
  
  def show
    @community = Community.find(params[:id]) if params[:id]
  end
  
  def index
    @communities = Community.all
  end
  
  def new
    @community = Community.new
    if !current_user.can_create(@community)
      render_insufficient_privileges
    else
      @community.errors.add(:name, 'Fart face poop 1')
      @community.errors.add(:slogan, 'Fart face poop 2a')
      @community.errors.add(:slogan, 'Fart face poop 2b')
      @community.errors.add(:label, 'Fart face poop 3')
      @community.errors.add(:accepting, 'Fart face poop 4')
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
        @community.assign_admin_role(current_user)
      end
      grab_all_errors_from_model(@community)
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
      grab_all_errors_from_model(@community)
      respond_with(@community)
    end
  end
end
