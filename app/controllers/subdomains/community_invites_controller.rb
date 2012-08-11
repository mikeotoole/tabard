class Subdomains::CommunityInvitesController < SubdomainsController
respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!

###
# REST Actions
###
  # GET /communities
  def index
    @community_invites = current_community.community_invites
    authorize! :index, CommunityInvite
  end

  # POST /communities(.:format)
  def create
    @community_invite = current_community.community_invites.new(params[:community_invite])
    authorize! :create, @community_invite
    @community_invite.save
  end
end
