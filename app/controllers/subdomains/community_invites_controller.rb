class Subdomains::CommunityInvitesController < SubdomainsController
respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!
  before_filter :load_community_invites

###
# REST Actions
###
  # GET /communities
  def index
    authorize! :index, CommunityInvite
    @community_invite = current_community.community_invites.new
  end

  # POST /communities(.:format)
  def create
    @community_invite = current_community.community_invites.new(params[:community_invite])
    authorize! :create, @community_invite
    @community_invite.sponsor = current_user.user_profile
    if @community_invite.save
      add_new_flash_message 'Invite was successfully created.','success'
      @community_invite = current_community.community_invites.new
    end
    render :index
  end

  def load_community_invites
    @community_invites = current_community.community_invites
  end
end
