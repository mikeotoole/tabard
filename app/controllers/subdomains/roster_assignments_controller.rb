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
  before_filter :block_unauthorized_user!, :except => [:index]
  before_filter :ensure_current_user_is_member, :except => [:index]
  before_filter :get_community_profile, :except => [:index]
  before_filter :load_roster_assignment, :except => [:new, :mine, :create, :approve, :reject]
  before_filter :load_pending_roster_assignment, :only => [:approve, :reject]
  before_filter :create_roster_assignment, :only => [:new, :mine, :create]
  before_filter :find_available_characters, :only => [:mine]
  authorize_resource :except => [:index, :game]
  skip_authorize_resource :only => [:pending]
  skip_before_filter :limit_subdomain_access

  # GET /roster_assignments
  # GET /roster_assignments.json
  def index
    raise CanCan::AccessDenied if (not current_community.is_public_roster) and (not user_signed_in? or not current_user.is_member?(current_community))
    @member_profiles = current_community.member_profiles.page params[:page]
  end

  # GET /roster_assignments
  # GET /roster_assignments.json
  def mine
    community_profile = current_user.community_profiles.find_by_community_id(current_community.id)
    @roster_assignments = Array.new
    @roster_assignments = community_profile.roster_assignments if community_profile
    render :new
  end
  alias :new :mine
  
  # GET /roster_assignments/game/:id(.:format)
  def game
    raise CanCan::AccessDenied if (not current_community.is_public_roster) and (not user_signed_in? or not current_user.is_member?(current_community))
    @supported_game = current_community.supported_games.find_by_id(params[:id])
    if !!@supported_game
      @member_profiles = @supported_game.member_profiles
    else
      redirect_to not_found_url
    end
  end

  # POST /roster_assignments
  # POST /roster_assignments.json
  def create
    if @roster_assignment.save
      @roster_assignment.approve if can? :manage, @roster_assignment
      if @roster_assignment.is_pending
        add_new_flash_message "Your request to add #{@roster_assignment.character_proxy_name} to the roster has been sent.", 'notice'
      else
        add_new_flash_message "#{@roster_assignment.character_proxy_name} has been added to the roster.", 'success'
      end
    end
    community_profile = current_user.community_profiles.find_by_community_id(current_community.id)
    @roster_assignments = Array.new
    @roster_assignments = community_profile.roster_assignments if community_profile
    respond_with @roster_assignment, :location => my_roster_assignments_path
  end

#   # PUT /roster_assignments/1 This is not needed.. Right? -MO
#   # PUT /roster_assignments/1.json
#   def update
#     #@roster_assignment = RosterAssignment.find(params[:id])
#     @roster_assignment.update_attributes(params[:roster_assignment])
#     respond_with(@roster_assignment)
#   end

  # DELETE /roster_assignments/1
  # DELETE /roster_assignments/1.json
  def destroy
    #@roster_assignment = RosterAssignment.find(params[:id])
    character_name = @roster_assignment.character_proxy_name
    if @roster_assignment.destroy
      add_new_flash_message "#{character_name} has been removed from the roster.", 'notice'
    end
    redirect_to my_roster_assignments_path
  end

  # DELETE /roster_assignments/batch_remove
  def batch_destroy
    if params[:ids]
      params[:ids].each do |id|
        roster_assignment = RosterAssignment.find_by_id(id)
        if can? :delete, roster_assignment
          roster_assignment.destroy
        end
      end
      add_new_flash_message "The roster has been updated.", 'notice'
    end
    redirect_to roster_assignments_path
  end

  # GET /roster_assignments/pending
  def pending
    authorize! :pending, RosterAssignment
    @roster_assignments = current_community.pending_roster_assignments
  end

  # PUT /roster_assignments/1/approve
  def approve
    @roster_assignment.approve
    add_new_flash_message "#{@roster_assignment.character_proxy_name} has been added to the community roster.", 'success'
    redirect_to pending_roster_assignments_path
  end

  # PUT /roster_assignments/batch_approve
  def batch_approve
    if params[:ids]
      params[:ids].each do |id|
        roster_assignment = RosterAssignment.find_by_id(id)
        if can? :update, roster_assignment
          roster_assignment.approve
        end
      end
      add_new_flash_message "The roster has been updated.", 'success'
    end
    redirect_to pending_roster_assignments_path
  end

  # PUT /roster_assignments/1/reject
  def reject
    @roster_assignment.reject
    add_new_flash_message "You have rejcted #{@roster_assignment.character_proxy_name} from joining the roster.", 'notice'
    redirect_to pending_roster_assignments_path
  end

  # PUT /roster_assignments/batch_reject
  def batch_reject
    if params[:ids]
      params[:ids].each do |id|
        roster_assignment = RosterAssignment.find_by_id(id)
        if can? :update, roster_assignment
          roster_assignment.reject
        end
      end
      add_new_flash_message "The roster has been updated.", 'success'
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
    @community_profile = current_user.community_profiles.where(:community_id => current_community.id).first
    return false unless @community_profile #this means that they are nit a member of this community
  end

  ###
  # _before_filter_
  #
  # This before filter attempts to populate @roster_assignments and @roster_assignment for the current_community and current_user.
  ###
  def load_roster_assignment
    if @supported_game
      @roster_assignments = current_community.roster_assignments.where(:supported_game => @supported_game)
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
    @available_characters = current_user.character_proxies - @community_profile.character_proxies
    @available_characters << @roster_assignment.character_proxy if @roster_assignment and @roster_assignment.character_proxy
  end
end
