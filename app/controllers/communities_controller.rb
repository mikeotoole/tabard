###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for communities.
###
class CommunitiesController < ApplicationController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!, :except => [:show, :index]
  skip_before_filter :ensure_not_ssl_mode, :only => [:destroy]
  skip_before_filter :limit_subdomain_access, :only => [:destroy]
  before_filter :ensure_secure_subdomain, :only => [:destroy]
  load_and_authorize_resource :except => [:create]

###
# REST Actions
###
  # GET /communities(.:format)
  def index
    @communities = @communities.order(:name).page params[:page]
  end

  # GET /communities/:id(.:format)
  def show
    redirect_to root_url(:subdomain => @community.subdomain)
  end

  # GET /communities/new(.:format)
  def new
    @community.admin_profile = current_user.user_profile
  end

  # POST /communities(.:format)
  def create
    @community = Community.new(params[:community])
    @community.admin_profile = current_user.user_profile
    authorize! :create, @community
    if @community.save
      redirect_to supported_games_url(:subdomain => @community.subdomain)
    else
      respond_with(@community)
    end
  end
  
  # DELETE /communities/:id(.:format)
  def destroy
    if params[:user] and current_user.valid_password?(params[:user][:current_password])
      Community.delay.destory_community(@community.id)
      @community.update_attribute(:pending_removal, true)
      add_new_flash_message 'Community is being removed.', 'notice'
      redirect_to user_root_url(:subdomain => false)
    else
      add_new_flash_message 'Password was not valid.', 'alert'
      redirect_to community_remove_confirmation_url(:subdomain => @community.subdomain)
    end
  end
end
