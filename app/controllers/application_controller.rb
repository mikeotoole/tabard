###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the application cotroller.
###
class ApplicationController < ActionController::Base
  include Exceptions
  # Turn on request forgery protection. Bear in mind that only non-GET, HTML/JavaScript requests are checked.
  protect_from_forgery

###
# Callbacks
###
  # This before_filter will requre that a user is authenticated.
  before_filter :block_unauthorized_user!

  # This before_filter will prevent the actions from taking place in a subdomain.
  before_filter :limit_subdomain_access

  # This before_filter checks if user needs to be logged out.
  before_filter :check_force_logout

  # This before_filter checks if system is in maintenance mode.
  before_filter :check_maintenance_mode

  # This before_filter ensures that a user has accepted legal documents.
  before_filter :ensure_accepted_most_recent_legal_documents

  # This before_filter ensures that a user is in good payment standing
  before_filter :ensure_user_is_in_good_payment_standing

  # This before_filter ensures that ssl mode is not running
  prepend_before_filter :ensure_not_ssl_mode

  # This before_filter set the time zone to the users given value.
  before_filter :set_timezone

  # This before_filter checks browser is supported.
  before_filter :check_supported_browser

  # Allow subdomains to punch through to www
  after_filter :set_access_control_headers

###
# Status Code Rescues
###
  # This method rescues from a CanCan Access Denied Exception
  rescue_from CanCan::AccessDenied do |exception|
    http_status_code(:forbidden, exception)
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    http_status_code(:not_found, exception)
  end

  ###
  # This method will attempt to render a status code according to the arguments that are passed to it.
  # [Args]
  #   * +status+ -> This is the status code to use. Rails defines this for us.
  #   * +exception+ -> This is an exception message to include.
  ###
  def http_status_code(status, exception = nil)
    if exception
      # store the exception so its message can be used in the view
      @exception = exception
      flash[:alert] = @exception.message unless @exception.message.blank?
    end
    # Only add the error page to the status code if the reuqest-format was HTML
    respond_to do |format|
      case status
      when :forbidden
        format.html { render "status_code/forbidden", status: status, layout: 'application' }
      when :not_found
        format.html { render "status_code/not_found", status: status, layout: 'application' }
      when :service_unavailable
        format.html { render "status_code/service_unavailable", status: status, layout: 'application' }
      else
        format.html { render "status_code/index", status: status, layout: 'application' }
      end
      format.any  { head status } # only return the status code
    end
  end

###
# Active Admin
###
  # Returns current cancan ability for current user/admin_user.
  def current_ability
    if current_admin_user
      @current_ability ||= AdminAbility.new(current_admin_user)
    else
      @current_ability ||= Ability.new(current_user)
    end
  end

###
# Protected Methods
###
protected

###
# Class Methods
###
  # Overrides default responder
  def self.responder
    AppResponder
  end

###
# Helper Methods
###

  # This gets a timezone collection hash
  def timezone_collection_hash
    [
      [[ActiveSupport::TimeZone[-11].to_s, -11]],
      (-11..-4).to_a.map{|z| z = [ActiveSupport::TimeZone.us_zones[z+10].to_s, z]},
      (-4..13).to_a.map{|z| z = [ActiveSupport::TimeZone[z].to_s, z]}
    ].flatten(1)
  end
  helper_method :timezone_collection_hash

###
# Remember Last Poster
###
  # This method sets the last poster.
  def set_last_posted_as(profile)
    # TODO harden this
    session[:poster_type] = profile.class.to_s
    session[:poster_id] = profile.id.to_s
  end
  # This method gets the character id of the last posted character
  def last_posted_as_character_id
    return nil if session[:poster_type].blank? or session[:poster_id].blank? or !!(session[:poster_type] =~ /UserProfile/)
    return session[:poster_id].to_i
  end
  helper_method :last_posted_as_character_id

  # This method determines is a user profile was last used to post.
  def last_posted_as_user_profile?(poster)
    return true if session[:poster_type].blank? or session[:poster_id].blank?
    return (poster.class.to_s == session[:poster_type].to_s and poster.id.to_s == session[:poster_id].to_s)
  end
  helper_method :last_posted_as_user_profile?

  # This determines if the provided was the one that was used to post last.
  def last_posted_as_character?(poster)
    return (poster.class.to_s == session[:poster_type].to_s and poster.id.to_s == session[:poster_id].to_s)
  end
  helper_method :last_posted_as_character?

  ###
  # This helper method returns the current community that is in scope.
  # It is defined as nil when not in a subdomain.
  ###
  def current_community
    nil
  end
  helper_method :current_community

  ###
  # This helper method returns determines what announcements to display
  ###
  def announcements_to_display
    if user_signed_in?
      @announcements_to_display ||= current_user.unread_announcements.recent.ordered
      return @announcements_to_display
    end
    return Array.new
  end
  helper_method :announcements_to_display

  ###
  # This helper method returns determines if there are any announcements to display
  ###
  def any_announcements_to_display?
    return announcements_to_display.size > 0
  end
  helper_method :any_announcements_to_display?

  ###
  # This helper method returns the current game that is in scope.
  # It is defined as nil when not in a game scope.
  ###
  def current_game
    nil
  end
  helper_method :current_game

  ###
  # This helper provides sort direction for controllers.
  ###
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  helper_method :sort_direction

  ###
  # This helper method gets the agent orange user agent.
  # Returns true if supported.
  ###
  def orange_user_agent
    @agent_orange_user_agent ||= AgentOrange::UserAgent.new(request.headers["HTTP_USER_AGENT"].downcase)
    return @agent_orange_user_agent
  end
  helper_method :orange_user_agent

  ###
  # This helper method that checks current browser is supported.
  # Returns true if supported.
  ###
  def browser_supported?
    ua = orange_user_agent
    return true if ua.device.is_bot?
    browser = ua.device.engine.browser
    return true if browser.type.to_s == 'safari' and browser.version.major.to_i >= 5
    return true if browser.type.to_s == 'chrome' and browser.version.major.to_i >= 17
    #return true if browser.type == 'ie' and browser.version.major.to_i >= 9
    return true if browser.type.to_s == 'firefox' and browser.version.major.to_i >= 10
    return false
  end
  helper_method :browser_supported?

  ###
  # This helper method provides access to text helpers such as pluralize within the controller
  ###
  def help
    Helper.instance
  end

  ###
  # This helper class provides access to text helpers such as pluralize within the controller
  ###
  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end

###
# Callback Methods
###

###
# Before Filters
###
  ###
  # _before_filter_
  #
  # This method limits a controller to prevent subdomain access, redirecting to root if the subdomain is present.
  # The allows us to white list controller that inherit from application controller.
  ###
  def limit_subdomain_access
    if request.subdomain.present? and request.subdomain != 'www'
      redirect_to [request.protocol, 'www.', request.domain, request.port_string, request.path].join # Try to downgrade gracefully...
      #redirect_to root_url(subdomain: "www"), alert: "Invalid action on a subdomain."
    end
  end

  ###
  # _before_filter_
  #
  # This method ensures that the request is located at https://secure.
  # If not it will try to redirect to that location in the secure mode.
  ###
  def ensure_secure_subdomain
    if not Rails.env.test?
      the_subdomain = request.subdomain
      the_protocol = request.protocol

      the_subdomain = "secure" if not(request.subdomain.present?) or request.subdomain != "secure"
      the_protocol = "https://" if !Rails.env.development? and request.protocol != "https://"

      redirect_to [the_protocol, (the_subdomain.blank? ? "" : "#{the_subdomain}."), request.domain, request.port_string, request.path].join if the_protocol != request.protocol or the_subdomain != request.subdomain # Try to downgrade gracefully...
    end
  end

  ###
  # _before_filter_
  #
  # This method ensures that the protocol is not https://.
  # If it is, it will try to redirect to that location with the http:// protocol.
  ###
  def ensure_not_ssl_mode
    the_protocol = request.protocol

    the_protocol = "http://" if !Rails.env.development? or request.protocol == "https://"

    redirect_to [the_protocol, (request.subdomain.blank? ? "" : "#{request.subdomain}."), request.domain, request.port_string, request.path].join if the_protocol != request.protocol # Try to downgrade gracefully...
  end

  ###
  # _before_filter_
  #
  # This looks to see if the user should be forced to logout after an Admin forces all logged in users to logout.
  ###
  def check_force_logout
    if current_user and current_user.force_logout
      flash[:notice] = 'You have been logged out for system maintenance'
      redirect_to destroy_user_session_path
    end
  end

  ###
  # _before_filter_
  #
  # This looks to see if the system is in maintenance mode. If so all traffic is redirected to the maintenance page.
  ###
  def check_maintenance_mode
    if SiteConfiguration.is_maintenance?
      redirect_to top_level_maintenance_url
    else
      true
    end
  end

  ###
  # _before_filter_
  #
  # This method ensures that a profile is active, or it will default to the user_profile
  ###
  def ensure_accepted_most_recent_legal_documents
    if user_signed_in?
      if not current_user.accepted_current_terms_of_service
        redirect_to accept_document_path(TermsOfService.current)
      elsif not current_user.accepted_current_privacy_policy
        redirect_to accept_document_path(PrivacyPolicy.current)
      end
    end
  end

  ###
  # _before_filter_
  #
  # This method ensures that a profile is active, or it will default to the user_profile
  ###
  def ensure_user_is_in_good_payment_standing
    if user_signed_in? and not current_user.is_in_good_account_standing
      # card_url
      flash[:notice] = "Uh oh. Your subscription is overdue. Please #{view_context.link_to('update your card', card_url)} to keep your service active."
    end
  end

  ###
  # _before_filter_
  #
  # This method is a custom replacement to authenticate_user! provided by devise to get around the path/url issue.
  ###
  def block_unauthorized_user!
    session[:return_to] = request.url
    authenticate_user!
  end

  ###
  # _before_filter_
  #
  # Signs out the current admin user if present. This method is used by the devise controllers when a regular user is signed in.
  ###
  def sign_out_admin_user
    sign_out(current_admin_user) if current_admin_user
  end

  ###
  # _before_filter_
  #
  # This method will set the time zone to the users given value. This will ensure the views disply the correct time.
  ###
  def set_timezone
    if current_user and defined? current_user.time_zone
      Time.zone = cookies[:timezone] = current_user.time_zone
    elsif !!cookies[:timezone]
      Time.zone = cookies[:timezone].to_i
    end
  end

  ###
  # _before_filter_
  #
  # This method will check if the users browser is supported. If not it will redirect to explination on why not.
  ###
  def check_supported_browser
    return true if Rails.env.test?
    if session[:supported_browser] or browser_supported?
      session[:supported_browser] = true unless session[:supported_browser]
    else
      session[:supported_browser] = false
      redirect_to unsupported_browser_url
    end
  end

  ###
  # _after_filter_
  #
  # This method allows requests to be sent to www from community subdomains
  ###
  def set_access_control_headers
    if current_community != nil
      # Subdomain -> www request
    else
      # www -> subdomain request
      origin = request.env['HTTP_ORIGIN']
      begin
        origin_uri = URI.parse(request.env['HTTP_ORIGIN'])
        some_subdomain = origin_uri.hostname.split('.').first
        # TODO add check to make sure this is ours....
        if not origin.blank? and not some_subdomain.blank? and Community.where{subdomain == some_subdomain}.exists?
          headers['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN']
          headers['Access-Control-Request-Method'] = '*'
        end
      rescue
      end
    end
  end

###
# Devise
###
  # This method overrides the default devise method to set the proper protocol and subdomain
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      root_url_hack_helper(user_profile_url(current_user.user_profile, protocol: "http://", subdomain: "www") + '#characters')
    when :admin_user, AdminUser
      alexandria_dashboard_url(subdomain: "secure")
    else
      user_root_url(current_user)
    end
  end

  # This method overrides the default devise method to set the proper protocol and subdomain
  def after_sign_out_path_for(resource_or_scope)
    root_url_hack_helper(root_url(protocol: "http://", subdomain: "www")) if resource and resource.kind_of?(User)
    return root_url
  end

###
# System Hacks
###
  # This method replaces the default url_for in rails because they think that url_for(subdomain: "www") is ambiguous.
  def root_url_hack_helper(the_broken_url)
    return the_broken_url.sub('secure.', '')
    return stored_location_for(resource)
  end
end
