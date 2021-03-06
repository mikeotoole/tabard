###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for roster assignments.
###
class Subdomains::RosterAssignmentsController < SubdomainsController
  respond_to :html

###
# Before Filters
###
  prepend_before_filter :block_unauthorized_user!, except: [:index, :game]
  before_filter :ensure_current_user_is_member, except: [:index, :game]
  before_filter :get_community_profile, except: [:index, :game]
  before_filter :load_roster_assignment, except: [:new, :mine, :create, :approve, :reject]
  before_filter :load_pending_roster_assignment, only: [:approve, :reject]
  before_filter :create_roster_assignment, only: [:new, :mine, :create]
  before_filter :find_available_characters, only: [:mine, :create, :new]
  authorize_resource except: [:index, :game]
  skip_authorize_resource only: [:pending]
  before_filter :ensure_roster_is_public, only: [:index, :game]

  # GET /roster_assignments
  # GET /roster_assignments.json
  def index
    @member_profiles = current_community.member_profiles.except(:order).search(params[:search]).order("LOWER(#{sort_column}) #{sort_direction}").page params[:page]
  end

  # GET /roster_assignments
  # GET /roster_assignments.json
  def mine
    community_profile = current_user.community_profiles.find_by_community_id(current_community.id)
    @roster_assignments = Array.new
    @roster_assignments = community_profile.roster_assignments.sort_by(&:character_name) if community_profile
    render :new
  end
  alias :new :mine

  # GET /roster_assignments/game/:id(.:format)
  def game
    @community_game = current_community.community_games.find_by_id(params[:id])
    if !!@community_game
      @member_profiles = Kaminari.paginate_array(@community_game.member_profiles).page params[:page]
    else
      redirect_to not_found_url
    end
  end

  # POST /roster_assignments
  # POST /roster_assignments.json
  def create
    if @roster_assignment.save
      @roster_assignment.approve(current_user.user_profile_id != @roster_assignment.community_profile_user_profile_id) if can? :manage, @roster_assignment
      if @roster_assignment.is_pending
        flash[:notice] = "Your request to add #{@roster_assignment.character_name} to the roster has been sent."
      else
        flash[:success] = "#{@roster_assignment.character_name} has been added to the roster."
      end
    end
    community_profile = current_user.community_profiles.find_by_community_id(current_community.id)
    @roster_assignments = Array.new
    @roster_assignments = community_profile.roster_assignments if community_profile
    respond_with @roster_assignment, location: my_roster_assignments_path
  end

  # DELETE /roster_assignments/1
  # DELETE /roster_assignments/1.json
  def destroy
    #@roster_assignment = RosterAssignment.find(params[:id])
    character_name = @roster_assignment.character_name
    if @roster_assignment.destroy
      flash[:notice] = "#{character_name} has been removed from the roster."
    end
    redirect_to my_roster_assignments_path
  end

  # DELETE /roster_assignments/batch_remove
  def batch_destroy
    if params[:ids]
      params[:ids].each do |id|
        roster_assignment = RosterAssignment.find_by_id(id)
        if can? :destroy, roster_assignment
          roster_assignment.destroy
        end
      end
      flash[:notice] = "The roster has been updated."
    end
    redirect_to roster_assignments_path
  end

  # GET /roster_assignments/pending
  def pending
    authorize! :pending, RosterAssignment
    @roster_assignments = current_community.pending_roster_assignments.sort_by(&:character_name)
  end

  # PUT /roster_assignments/1/approve
  def approve
    @roster_assignment.approve(current_user.user_profile_id != @roster_assignment.community_profile_user_profile_id)
    flash[:success] = "#{@roster_assignment.character_name} has been added to the community roster."
    redirect_to pending_roster_assignments_path
  end

  # PUT /roster_assignments/batch_approve
  def batch_approve
    if params[:ids]
      params[:ids].each do |id|
        roster_assignment = RosterAssignment.find_by_id(id)
        if can? :update, roster_assignment
          roster_assignment.approve(current_user.user_profile_id != roster_assignment.community_profile_user_profile_id)
        end
      end
      flash[:success] = "The roster has been updated."
    end
    redirect_to pending_roster_assignments_path
  end

  # PUT /roster_assignments/1/reject
  def reject
    @roster_assignment.reject(current_user.user_profile_id != @roster_assignment.community_profile_user_profile_id)
    flash[:notice] = "You have rejcted #{@roster_assignment.character_name} from joining the roster."
    redirect_to pending_roster_assignments_path
  end

  # PUT /roster_assignments/batch_reject
  def batch_reject
    if params[:ids]
      params[:ids].each do |id|
        roster_assignment = RosterAssignment.find_by_id(id)
        if can? :update, roster_assignment
          roster_assignment.reject(current_user.user_profile_id != roster_assignment.community_profile_user_profile_id)
        end
      end
      flash[:success] = "The roster has been updated."
    end
    redirect_to pending_roster_assignments_path
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to locate the community profile of current_user
  ###
  def get_community_profile
    return false unless current_user.community_profiles # This means that they are not a member of this community
    @community_profile = current_user.community_profiles.where(community_id: current_community.id).first
    return false unless @community_profile #this means that they are nit a member of this community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to populate @roster_assignments and @roster_assignment for the current_community and current_user.
  ###
  def load_roster_assignment
    if @community_game
      @roster_assignments = current_community.roster_assignments.where(community_game: @community_game)
    else
      @roster_assignments = current_community.roster_assignments
    end
    @roster_assignment = RosterAssignment.find_by_id(params[:id])
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to populate @roster_assignment for the current_community's pending roster_assignments
  ###
  def load_pending_roster_assignment
    @roster_assignment = current_community.pending_roster_assignments.find_by_id(params[:id])
  end

  ###
  # _before_filter
  #
  # This before filter attempts to create @roster_assignment from: roster_assignments.new(params[:roster_assignment]) or roster_assignments.new(), for the current community and current_user.
  ###
  def create_roster_assignment
    if(params[:roster_assignment])
      @roster_assignment = @community_profile.roster_assignments.new(params[:roster_assignment])
    else
      @roster_assignment = @community_profile.roster_assignments.new
    end
  end

  ###
  # _before_filter
  #
  # This before filter gets the characters for the available characters drop down.
  ###
  def find_available_characters
    @available_characters = current_user.compatable_characters(current_community) - @community_profile.characters
    @available_characters << @roster_assignment.character if @roster_assignment and @roster_assignment.character
  end

  ###
  # _before_filter
  #
  # This before filter check for public roster
  ###
  def ensure_roster_is_public
    raise CanCan::AccessDenied if (not current_community.is_public_roster) and (not user_signed_in? or not current_user.is_member?(current_community))
  end

  def enforce_community_features
    if current_community.is_disabled? and can? :accept, CommunityApplication
      overage_count = current_community.community_profiles.count - current_community.max_number_of_users
      upgrade_link = edit_subscription_url(current_community)
      flash[:alert] = "This community is over capacity by #{view_context.pluralize overage_count, 'member', 'members'}. #{view_context.link_to 'Upgrade your subscription', upgrade_link} or remove some of your members."
      return true
    else
      super
    end
  end

###
# Helper methods
###
  helper_method :sort_column
private
  def sort_column
    UserProfile.column_names.include?(params[:sort]) ? params[:sort] : "display_name"
  end
end
