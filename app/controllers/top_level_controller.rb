###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the controller for top level pages (http://<domain name>/<page name>)
###
class TopLevelController < ApplicationController
  caches_page :intro, :features, :pricing, :privacy_policy, :terms_of_service, :support
  before_filter(only: [:intro, :features, :pricing, :privacy_policy, :terms_of_service, :support]) { @page_caching = true }
  respond_to :html, :js
###
# Callbacks
###
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_maintenance_mode, only: [:maintenance]
  skip_before_filter :ensure_accepted_most_recent_legal_documents, only: [:bar, :ignore_browser]
  skip_before_filter :limit_subdomain_access, only: [:bar, :ignore_browser]
  skip_before_filter :ensure_not_ssl_mode, only: [:bar, :ignore_browser]
  skip_before_filter :check_supported_browser

###
# Actions
###
  ###
  # This method gets the index for home.
  # If no match constraints(Subdomain)
  # GET /
  ###
  def index
    redirect_to user_profile_url(current_user.user_profile, subdomain: false) + '#characters' if user_signed_in?
  end

  ###
  # This method returns the bar in/out partial for dynamic loading
  # GET /bar(.:format)
  ###
  def bar
    if user_signed_in?
      render partial: "layouts/bar_in"
    else
      render partial: "layouts/bar_out"
    end
  end

  # This method gets the Introduction page.
  #def intro
  #end

  # This method gets the Features page.
  def features
  end

  # This method gets the Pricing page.
  def pricing
  end

  # This method gets the Maintenance page.
  def maintenance
    if SiteConfiguration.is_maintenance?
      render 'maintenance', layout: nil, status: 503
    else
      redirect_to root_url
    end
  end

  # This method gets the Privacy Policy page.
  def privacy_policy
    @document = PrivacyPolicy.current
  end

  # This method gets the Terms of Service page.
  def terms_of_service
    @document = TermsOfService.current
  end

  # This method will bypass the supported browser check for the users current session.
  def ignore_browser
    session[:supported_browser] = true
    redirect_to root_url
  end
end
