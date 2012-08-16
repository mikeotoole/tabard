class Subdomains::CommunityInvitesController < SubdomainsController
  respond_to :html, :js
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

  # POST /community_invites/mass_create(.:format)
  def mass_create
    @community_invite = current_community.community_invites.new
    authorize! :create, @community_invite
    @number_created = 0
    @number_failed = 0
    unless (params[:emails].blank? or not params[:emails].any?)
      params[:emails].each do |email|
        invite = current_community.community_invites.new({sponsor: current_user.user_profile, email: email}, without_protection: true)
        if invite.save
          @number_created = @number_created + 1
        else
          @number_failed = @number_failed + 1
        end
      end
    end
    unless (params[:users].blank? or not params[:users].any?)
      params[:users].each do |user|
        invite = current_community.community_invites.new({sponsor: current_user.user_profile, applicant_id: user}, without_protection: true)
        if invite.save
          @number_created = @number_created + 1
        else
          @number_failed = @number_failed + 1
        end
      end
    end
    flash[:sucess] = "#{@number_created} recruit invitation#{@number_failed > 1 ? 's' : ''} sent!" if @number_created > 0
    flash[:error] = "#{@number_failed} recruit invitation#{@number_failed > 1 ? 's' : ''} failed to be sent." if @number_failed > 0
    redirect_to community_invites_url
  end

  # GET /community_invites/autocomplete(.:format)
  def autocomplete
    @community_invite = current_community.community_invites.new
    authorize! :create, @community_invite
    number_to_fetch = 10
    if params[:term].blank? or params[:term].to_s.length < 2
      render json: { results: [] }
    else
      result_1_argument = "#{params[:term]}%"
      results_1 = UserProfile.where{display_name =~ result_1_argument}.limit(number_to_fetch)
      result_2_argument = "%#{params[:term]}%"
      results_2 = UserProfile.where{display_name =~ result_2_argument}.limit(number_to_fetch)
      @user_profiles = (results_1 + results_2).uniq[0,number_to_fetch]
      render json: @user_profiles.map{|p| p = {label: p.display_name, value: p.id, avatar: p.avatar_url(:icon)}}
    end
  end

  def load_community_invites
    @community_invites = current_community.community_invites
  end
end
