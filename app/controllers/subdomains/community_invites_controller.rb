class Subdomains::CommunityInvitesController < SubdomainsController
  respond_to :html
  ###
  # Before Filters
  ###
  before_filter :block_unauthorized_user!
  before_filter :load_community_invites
  before_filter :ensure_current_user_is_member

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

  # POST /community_invites/mass_create(.:format)
  def mass_create
    @community_invite = current_community.community_invites.new
    authorize! :create, @community_invite
    @number_created = 0
    unless (params[:emails].blank? or not params[:emails].any?)
      params[:emails].each do |email|
        invite = current_community.community_invites.new({sponsor: current_user.user_profile, email: email}, without_protection: true)
        if invite.save
          @number_created = @number_created + 1
        else
          logger.debug "!!! #{invite.errors.to_yaml}"
        end
      end
    end
    unless (params[:users].blank? or not params[:users].any?)
      params[:users].each do |user|
        invite = current_community.community_invites.new({sponsor: current_user.user_profile, applicant_id: user}, without_protection: true)
        if invite.save
          @number_created = @number_created + 1
        else
          logger.debug "!!! #{invite.errors.to_yaml}"
        end
      end
    end

  end

  # PUT /community_invites/mass_create(.:format)
  def autocomplete
    @community_invite = current_community.community_invites.new
    authorize! :create, @community_invite
    number_to_fetch = 10
    return Array.new if param[:term].blank? or param[:term].to_s.length <= 2
    result_1_argument = "#{param[:term]}%"
    results_1 = UserProfile.where{display_name =~ result_1_argument}.limit(10)
    result_2_argument = "%#{param[:term]}%"
    results_2 = UserProfile.where{display_name =~ result_2_argument}.limit(results_1.size)
    return results_1 + results_2
  end

  def load_community_invites
    @community_invites = current_community.community_invites
  end
end
