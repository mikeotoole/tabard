###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
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
  before_filter :block_unauthorized_user!, :except => [:index]
  skip_before_filter :limit_subdomain_access

###
# REST Actions
###
  ###
  # Index action
  # If constraints(Subdomain) match
  # GET /
  ###
  def index
    if user_signed_in? and current_user.is_member? @community
      @activities_count_initial = 20
      @activities_count_increment = 10
      @activities = Activity.activities({ community_id: @community.id }, nil, @activities_count_initial)
      render :community_dashboard
    else
      @page = current_community.home_page if !!current_community.home_page
      render :community_home
    end
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

  ###
  # This method is a helper that exposes all of the mangement items.
  ###
  def management_navigation_items
    management_items = Array.new()
    return management_items unless signed_in?
    #application
    management_items << {:link => edit_community_settings_path, :title => "Community Settings"} if can_manage(current_community)
    management_items << {:link => supported_games_url, :title => "Supported Games"} if can_manage(current_community.supported_games.new)
    management_items << {:link => roles_url, :title => "Permissions"} if can_manage(current_community.roles.new)
    management_items << {:link => community_applications_path, :title => 'Applications', :meta => current_community.pending_applications.size} if can_manage(current_community.community_applications.new()) or can? :read, CommunityApplication
    management_items << {:link => pending_roster_assignments_url, :title => "Roster Requests", :meta => current_community.pending_roster_assignments.size} if can? :pending, RosterAssignment
    management_items << {:link => my_roster_assignments_url, :title => "My Roster"} if can? :mine, RosterAssignment
    management_items << {:link => custom_forms_url, :title => "Forms"} if can_manage(current_community.custom_forms.new)
    management_items
  end
  helper_method :management_navigation_items

  def announcements_to_display
    return current_user.recent_unread_announcements.where(community_id: current_community.id) if user_signed_in? and current_community
    return Array.new
  end
  helper_method :announcements_to_display

###
# Protected Methods
###
protected

  ###
  # This method conveniently checks to see whether the user can do any admin level functions on a given resource.
  ###
  def can_manage(resource)
    (can? :update, resource) or (can? :destroy, resource) or (can? :accept, resource) or (can? :reject, resource)
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
    if @community
      return true
    else
      redirect_to [request.protocol, request.domain, request.port_string, request.path].join, :alert => "That community does not exist"
      return false
    end
  end

  ###
  # This method apply dynamic permissions based on the current community.
  ###
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

###
# Helper Methods
###
  # This helper method lets the community layout view know when to use the default theme
  def use_default_theme?
    !!@use_default_theme
  end
  helper_method :use_default_theme?
end
