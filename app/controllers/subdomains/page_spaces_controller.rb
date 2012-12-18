###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling page spaces within the scope of subdomains (communities).
###
class Subdomains::PageSpacesController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_page_space, except: [:new, :create, :index]
  before_filter :create_page_space, only: [:new, :create]
  authorize_resource except: :index
  skip_before_filter :limit_subdomain_access
  after_filter :create_activity, only: [:update, :create]

###
# REST Actions
###
  # GET /page_spaces(.:format)
  def index
    @page_spaces = Kaminari.paginate_array(current_community.page_spaces.includes(:community_game).reject{|d| !can? :show, d }).page params[:page]
  end

  # GET /page_spaces/:id(.:format)
  def show
    @pages = Kaminari.paginate_array(@page_space.pages.reject{|d| !can? :show, d }).page params[:page]
  end

  # GET /page_spaces/new(.:format)
  def new
  end

  # GET /page_spaces/:id/edit(.:format)
  def edit
    respond_with(@page_space)
  end

  # POST /page_spaces(.:format)
  def create
    if @page_space.save
      flash[:success] = 'Page space has been created.'
      @action = 'created'
    end
    respond_with(@page_space)
  end

  # PUT /page_spaces/:id(.:format)
  def update
    @page_space.assign_attributes(params[:page_space])
    is_changed = @page_space.changed?

    if @page_space.save
      flash[:success] = 'Page space has been saved.'
      @action = is_changed ? 'edited' : nil
    end
    respond_with(@page_space)
  end

  # DELETE /page_spaces/:id(.:format)
  def destroy
    flash[:notice] = 'Page space was successfully removed.' if @page_space.destroy
    respond_with(@page_space, location: page_spaces_path)
  end

  # This method returns the current game that is in scope.
  def current_game
    @page_space.game if @page_space
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
  # This before filter attempts to populate @page_space from the current_community.
  ###
  def load_page_space
    @page_space = current_community.page_spaces.find_by_id(params[:id]) if current_community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to create @page_space from: page_spaces.new(params[:page_space]), for the current community.
  ###
  def create_page_space
    @page_space = current_community.page_spaces.new(params[:page_space]) if current_community
  end

  ###
  # _after_filter_
  #
  # This after filter will created a new activty when a page space is created or updated.
  ###
  def create_activity
    if @action
      Activity.create!( {user_profile: current_user.user_profile,
                        community: @page_space.community,
                        target: @page_space,
                        action: @action}, without_protection: true)
    end
  end
end
