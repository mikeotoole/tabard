###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling discussions within the scope of subdomains (communities).
###
class Subdomains::AnnouncementSpacesController < SubdomainsController
  respond_to :html
###
# Before Filters
###
  before_filter :block_unauthorized_user!
  before_filter :ensure_current_user_is_member
  before_filter :load_announcement_space, :only => :show
  skip_before_filter :limit_subdomain_access
  authorize_resource :except => :index

  def index
    @announcement_spaces = current_community.announcement_spaces
  end

  def show
  end
  
  # This method returns the current game that is in scope.
  def current_game
    @announcement_space ? @announcement_space.game : nil
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
  # This before filter attempts to populate @announcement_space from the current_community.
  ###
  def load_announcement_space
    @announcement_space = current_community.announcement_spaces.find_by_id(params[:id]) if current_community
  end
end
