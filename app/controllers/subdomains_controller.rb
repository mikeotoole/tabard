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
  before_filter :enforce_community_features
  before_filter :block_unauthorized_user!, except: [:index]
  before_filter :ensure_current_user_is_member, except: [:index]
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
    management_items << {link: edit_community_settings_url, title: "Community Settings", class: 'settings'} if can_manage? current_community
    management_items << {link: community_games_url, title: "Community Games", class: 'games'} if can_manage? current_community.community_games.new
    management_items << {link: roles_url, title: "Permissions", class: 'roles'} if can_manage? current_community.roles.new
    management_items << {link: community_invites_url, title: "Recruit Members", class: 'recruit'} if can? :create, CommunityInvite
    management_items << {link: community_applications_url, title: 'Applications', class: 'applications', meta: current_community.pending_applications.size} if can_manage?(current_community.community_applications.new()) or can? :index, CommunityApplication
    management_items << {link: pending_roster_assignments_url, title: "Roster Requests", class: 'roster', meta: current_community.pending_roster_assignments.size} if can? :pending, RosterAssignment
    management_items << {link: my_roster_assignments_url, title: "My Roster", class: 'myroster'} if can? :mine, RosterAssignment
    management_items
  end
  helper_method :management_navigation_items

  ###
  # This is the wiki items
  ###
  def wiki_items
    @wiki_items ||= current_community.page_spaces.reject{|d| !can? :show, d }
    return @wiki_items
  end
  helper_method :wiki_items

  ###
  # This is the discussion items
  ###
  def discussion_items
    @discussion_items ||= current_community.discussion_spaces.reject{|d| !can? :show, d }
    return @discussion_items
  end
  helper_method :discussion_items

  ###
  # This is the form items
  ###
  def form_items
    @form_items ||= current_community.custom_forms.published.reject{|d| !can? :show, d }
    return @form_items
  end
  helper_method :form_items

###
# Protected Methods
###
protected

  ###
  # This method conveniently checks to see whether the user can do any admin level functions on a given resource.
  ###
  def can_manage?(resource)
    (can? :update, resource) or (can? :destroy, resource) or (can? :accept, resource) or (can? :reject, resource)
  end
  helper_method :can_manage?

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
      render 'status_code/pending_removal', layout: 'application' if @community.pending_removal
      return true
    else
      redirect_to [request.protocol, request.domain, request.port_string, request.path].join, alert: "That community does not exist"
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
  # This method will enforce community is not disabled.
  ###
  def enforce_community_features
    if current_community.is_disabled?
      if user_signed_in?
        overage_count = current_community.community_profiles.count - current_community.max_number_of_users
        if current_user.owned_communities.include?(current_community)
          upgrade_link = edit_subscription_url(current_community,subdomain: "secure", protocol: (Rails.env.development? ? "http://" : "https://"))
          flash[:alert] = "This community is over capacity by #{view_context.pluralize overage_count, 'member', 'members'}. #{view_context.link_to 'Upgrade your subscription', upgrade_link} or remove some of your members."
          redirect_to roster_assignments_url(subdomain: current_community.subdomain)
          return false
        else
          if current_user.is_member? current_community
          flash[:alert] = "This community is over capacity by #{view_context.pluralize overage_count, 'member', 'members'}. The community admin will need to update this account."
          end
        end
      end
      flash[:alert] = "This community is currently disabled."
      redirect_to community_disabled_url
      return false
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

  ###
  # This helper method returns determines what announcements to display
  ###
  def announcements_to_display
    if user_signed_in?
      @announcements_to_display ||= current_user.unread_announcements.where(community_id: current_community.id).recent.ordered
      return @announcements_to_display
    end
    return Array.new
  end
  helper_method :announcements_to_display

end