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
  before_filter :authenticate_user!, :except => [:index]
  before_filter :ensure_current_user_is_member, :except => [:index]
  before_filter :get_community_profile, :except => [:index]
  before_filter :load_roster_assignment, :except => [:new, :create, :approve, :reject]
  before_filter :load_pending_roster_assignment, :only => [:approve, :reject]
  before_filter :create_roster_assignment, :only => [:new, :create]
  before_filter :find_avalible_characters, :except => [:index]
  authorize_resource
  skip_authorize_resource :only => [:pending]
  skip_before_filter :limit_subdomain_access

  # GET /roster_assignments
  # GET /roster_assignments.json
  def index
    #@roster_assignments = RosterAssignment.all
    #authorize! :index, RosterAssignment
    @member_profiles = current_community.member_profiles
  end

  # GET /roster_assignments
  # GET /roster_assignments.json
  def mine
    community_profile = current_user.community_profiles.find_by_community_id(current_community.id)
    @roster_assignments = Array.new
    @roster_assignments = community_profile.roster_assignments if community_profile
  end

  # GET /roster_assignments/1
  # GET /roster_assignments/1.json
  def show
    #@roster_assignment = RosterAssignment.find(params[:id])
  end

  # GET /roster_assignments/new
  # GET /roster_assignments/new.json
  def new
    #@roster_assignment = RosterAssignment.new
  end

  # GET /roster_assignments/1/edit
  def edit
    #@roster_assignment = RosterAssignment.find(params[:id])
  end

  # POST /roster_assignments
  # POST /roster_assignments.json
  def create
    #@roster_assignment = RosterAssignment.new(params[:roster_assignment])
    @roster_assignment.save
    respond_with(@roster_assignment)
  end

  # PUT /roster_assignments/1
  # PUT /roster_assignments/1.json
  def update
    #@roster_assignment = RosterAssignment.find(params[:id])
    @roster_assignment.update_attributes(params[:roster_assignment])
    respond_with(@roster_assignment)
  end

  # DELETE /roster_assignments/1
  # DELETE /roster_assignments/1.json
  def destroy
    #@roster_assignment = RosterAssignment.find(params[:id])
    @roster_assignment.destroy
    respond_with(@roster_assignment)
  end

  # GET /roster_assignments/pending
  def pending
    authorize! :pending, RosterAssignment
    @roster_assignments = current_community.pending_roster_assignments
  end

  # PUT /roster_assignments/1/approve
  def approve
    @roster_assignment.approve
    redirect_to(pending_roster_assignments_path)
  end

  # PUT /roster_assignments/1/reject
  def reject
    @roster_assignment.reject
    redirect_to(pending_roster_assignments_path)
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
    @roster_assignments = current_community.roster_assignments
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
  # This before filter gets the characters for the avalible characters drop down.
  ###
  def find_avalible_characters
    @avalible_characters = current_user.character_proxies - @community_profile.character_proxies
    @avalible_characters << @roster_assignment.character_proxy if @roster_assignment and @roster_assignment.character_proxy
  end
end
