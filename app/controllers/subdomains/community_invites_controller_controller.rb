class Subdomains::CommunityInvitesController < ApplicationController
respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!
  load_and_authorize_resource through: :current_community

###
# REST Actions
###
  # GET /communities
  def index
  end

  # POST /communities(.:format)
  def create
  end
end
