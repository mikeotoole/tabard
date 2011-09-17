###
# This class is responsible for orquestrating subdomains.
###
class SubdomainsController < ApplicationController
###
# Callbacks
###
  before_filter :find_community_by_subdomain
  before_filter :authenticate_user!, :except => [:index]
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

###
# Protected Methods
###
protected

  ###
  # This method attepts to find a community using the subdomain from the request.
  ###
  def find_community_by_subdomain
    @community = Community.find_by_subdomain(request.subdomain.downcase)
    redirect_to root_url(:subdomain => false), :alert => "That community does not exist" and return false unless @community
    false
  end
end