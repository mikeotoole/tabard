###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling pages within the scope of subdomains (communities).
###
class Subdomains::PagesController < SubdomainsController
  respond_to :html
  layout 'application'

###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  load_and_authorize_resource except: [:new, :create, :index]
  before_filter :create_page, only: [:new, :create]
  authorize_resource only: [:new, :create]
  after_filter :create_activity, only: [:update, :create]

###
# REST Actions
###

  # GET /pages/:id(.:format)
  def show
    respond_with @page, layout: 'community'
  end

  # GET /page_spaces/:page_space_id/pages/new(.:format)
  def new
  end

  # GET /pages/:id/edit(.:format)
  def edit
    respond_with @page
  end

  # POST /page_spaces/:page_space_id/pages(.:format)
  def create
    if @page.save
      flash[:success] = 'Page has been created.'
      @action = 'created'
    end
    respond_with @page
  end

  # PUT /pages/:id(.:format)
  def update
    if current_user.user_profile == current_community.admin_profile
      @page.assign_attributes(params[:page], as: :community_admin)
    else
      @page.assign_attributes(params[:page])
    end
    is_changed = @page.changed?
    if @page.save
      flash[:success] = 'Page has been saved.'
      @action = is_changed ? 'edited' : nil
    end
    respond_with @page
  end

  # DELETE /pages/:id(.:format)
  def destroy
    if @page.destroy
      flash[:notice] = 'Page was successfully removed.'
    else
      if @page.is_home_page?
        flash[:notice] = 'The commmunity home page can not be removed.'
      else
        flash[:notice] = 'Page was unable to be removed.'
      end
    end
    respond_with(@page, location: page_space_url(@page.page_space))
  end

  # This method returns the current game that is in scope.
  def current_game
    @page.page_space_game
  end
  helper_method :current_game

###
# Protected Methods
###
protected

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This before filter attempts to create @page from: pages.new(params[:page]), for the page space.
  ###
  def create_page
    page_space = current_community.page_spaces.find_by_id(params[:page_space_id])
    if current_user.user_profile == current_community.admin_profile
      @page = page_space.pages.new(params[:page], as: :community_admin)
    else
      @page = page_space.pages.new(params[:page])
    end
  end

  ###
  # _after_filter_
  #
  # This after filter will created a new activty when a page is created or updated.
  ###
  def create_activity
    if @action
      Activity.create( {user_profile: current_user.user_profile,
                        community: @page.community,
                        target: @page,
                        action: @action}, without_protection: true)
    end
  end
end
