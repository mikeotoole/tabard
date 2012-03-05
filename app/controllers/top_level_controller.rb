###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the controller for top level pages (http://<domain name>/<page name>)
###
class TopLevelController < ApplicationController
  caches_page :intro, :features, :pricing
  respond_to :html
###
# Callbacks
###
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :check_maintenance_mode, :only => [:maintenance]

###
# REST Actions
###
  ###
  # This method gets the index for home.
  # If no match constraints(Subdomain)
  # GET /
  ###
  def index
    redirect_to user_root_path if user_signed_in?
    # @recent_activity = Community.order{ created_at.desc }.last(5).collect{|community| {type: 'New Community', name: community.name, link: community_url(community), snippet: community.supported_games.collect{|game| game.name}.join(', ')}}
  end

  # This method gets the Introduction page.
  def intro
  end

  # This method gets the Features page.
  def features
  end

  # This method gets the Pricing page.
  def pricing
  end

  # This method gets the Maintenance page.
  def maintenance
    if SiteConfiguration.is_maintenance?
      render :layout => 'maintenance'
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
end
