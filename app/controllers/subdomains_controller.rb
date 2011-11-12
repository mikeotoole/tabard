###
# This class is responsible for orquestrating subdomains.
###
class SubdomainsController < ApplicationController
###
# Layout
###
  layout :community_layout

###
# Callbacks
###
  before_filter :find_community_by_subdomain
  before_filter :apply_dynamic_permissions
  before_filter :authenticate_user!, :except => [:index]
  skip_before_filter :limit_subdomain_access, :fetch_active_games

###
# REST Actions
###
  ###
  # Index action
  # If constraints(Subdomain) match
  # GET /
  ###
  def index
    render :index
  end
###
# Public Methods
###
  ###
  # This Method is a helper that exposes the current_community
  ###
  def current_community
    @community
  end

  helper_method :current_community

  def management_navigation_items
    management_items = Array.new()
    return management_items unless signed_in?
    #application
    management_items << {:link => edit_community_settings_path, :title => "Community Settings"} if can_manage(current_community)
    management_items << {:link => community_applications_path, :title => "Applications - #{current_community.pending_applications.size}"} if can_manage(current_community.community_applications.new())
    management_items << {:link => pending_roster_assignments_url, :title => "Pending Roster Membership"} if can? :pending, RosterAssignment
    management_items << {:link => my_roster_assignments_url, :title => "My Roster Membership"} if can? :mine, RosterAssignment
    management_items << {:link => custom_forms_url, :title => "Forms"} if can_manage(current_community.custom_forms.new)
    management_items << {:link => roles_url, :title => "Permissions"} if can_manage(current_community.roles.new)
    management_items
  end
  helper_method :management_navigation_items

###
# Protected Methods
###
protected

  ###
  # This method conveniently checks to see whether the user can do any admin level functions on a given resource.
  ###
  def can_manage(resource)
    (can? :update, resource) or (can? :destroy, resource) or (can? :approve, resource) or (can? :reject, resource)
  end
  
  ###
  # This method sets the layout for the controller.
  ###
  def community_layout
    "community" # This can be expanded later with logic.
  end

  ###
  # This method attepts to find a community using the subdomain from the request.
  ###
  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    redirect_to root_url(:subdomain => false), :alert => "That community does not exist" and return false unless @community
    false
  end

  def apply_dynamic_permissions
    current_ability.dynamicContextRules(current_user, current_community) if signed_in? or current_ability
  end

  ###
  # This method will ensure that the current_user is a member of current_community.
  ###
  def ensure_current_user_is_member
    if not current_user or not current_user.communities.include?(current_community)
      raise CanCan::AccessDenied
    end
  end
end
