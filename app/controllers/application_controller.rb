###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This is the application cotroller.
###
class ApplicationController < ActionController::Base
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

  # This before_filter ensures that ssl mode is not running
  prepend_before_filter :ensure_not_ssl_mode
  
  # This before_filter set the time zone to the users given value.
  before_filter :set_timezone
  
  # This before_filter checks browser is supported.
  before_filter :check_supported_browser

###
# Status Code Rescues
###
  # This method rescues from a CanCan Access Denied Exception
  rescue_from CanCan::AccessDenied do |exception|
    http_status_code(:forbidden, exception)
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
      flash[:alert] = @exception.message
    end
    # Only add the error page to the status code if the reuqest-format was HTML
    respond_to do |format|
      case status
      when :forbidden
        format.html { render "status_code/forbidden", :status => status, :layout => 'application' }
      else
        format.html { render "status_code/index", :status => status, :layout => 'application' }
      end
      format.any  { head status } # only return the status code
    end
  end

###
# Public Methods
###
  ###
  # Adds a new message to the flash messsages array
  # [Args]
  #   * +message_body+ -> The body of the message.
  #   * +message_class+ -> What type of message it is, including but not limited to "alert", "notice", "announcement", etc.
  #   * +message_title+ -> The title of the message.
  ###
  def add_new_flash_message(message_body, message_class="notice", message_title="")
    flash[:messages] = Array.new unless flash[:messages]
    flash[:messages] << { :class => message_class, :title => message_title, :body => message_body }
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

  # This helper method lets the applicaiton layout view know whether or not to hide announcements within the flash messages partial.
  def hide_announcements?
    !!@hide_announcements
  end
  helper_method :hide_announcements?

###
# Remember Last Poster
###
  # This method sets the last poster.
  def set_last_posted_as(profile)
    logger.debug "#{session[:poster_id]} #{session[:poster_type]} ? #{profile.to_yaml}"
    session[:poster_type] = (profile.class == UserProfile ? profile.class.to_s : profile.character_type.to_s)
    session[:poster_id] = profile.id.to_s
  end
  # This method gets the character proxy id of the last posted character
  def last_posted_as_character_proxy_id
    return nil if last_posted_as_user_profile?(Array.new)
    return session[:poster_id].to_i
  end
  helper_method :last_posted_as_character_proxy_id

  # This method determines is a user profile was last used to post.
  def last_posted_as_user_profile?(proxies)
    proxy_found = false
    logger.debug proxies.to_yaml
    proxies.each do |proxy|
      return false if last_posted_as_character_proxy?(proxy)
    end
    !session[:poster_type] or !session[:poster_id] or !!(session[:poster_type] =~ /UserProfile/) or not proxy_found
  end
  helper_method :last_posted_as_user_profile?

  # This determines if the provided proxy was the one that was used to post last.
  def last_posted_as_character_proxy?(proxy)
    logger.debug "#{session[:poster_id]} #{session[:poster_type]} ? #{(proxy.character_type.to_s == session[:poster_type].to_s and proxy.id.to_s == session[:poster_id].to_s)}"
    return (proxy.character_type.to_s == session[:poster_type].to_s and proxy.id.to_s == session[:poster_id].to_s)
  end
  helper_method :last_posted_as_character_proxy?

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
  # This helper method that checks current browser is supported.
  # Returns true if supported.
  ###
  def browser_supported?
    return true if browser.safari? and browser.version.to_i >= 6 
    return true if browser.chrome? and browser.version.to_i >= 10
    return true if browser.opera? and browser.version.to_i >= 11
    return true if browser.ie? and browser.version.to_i >= 9
    return true if browser.firefox? and browser.version.to_i >= 7
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
    if request.subdomain.present?
      redirect_to [request.protocol, request.domain, request.port_string, request.path].join # Try to downgrade gracefully...
      #redirect_to root_url(:subdomain => false), :alert => "Invalid action on a subdomain."
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
      add_new_flash_message('You have been logged out for system maintenance')
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
  # This method is a custom replacement to authenticate_user! provided by devise to get around the path/url issue.
  ###
  def block_unauthorized_user!
    session[:return_to] = request.url
    authenticate_user!
  end
  
  ###
  # _before_filter_
  #
  # This method will set the time zone to the users given value. This will ensure the views disply the correct time.
  ###
  def set_timezone
    Time.zone = current_user.time_zone if current_user
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
# Devise
###
  # This method overrides the default devise method to set the proper protocol and subdomain
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      root_url_hack_helper(user_profile_url(current_user.user_profile, :protocol => "http://", :subdomain => false) + '#characters')
    when :admin_user, AdminUser
      admin_dashboard_url(:protocol => "http://", :subdomain => false).sub('secure.', '')
    else
      user_root_url(current_user)
    end
  end

  # This method overrides the default devise method to set the proper protocol and subdomain
  def after_sign_out_path_for(resource_or_scope)
    root_url_hack_helper(root_url(:protocol => "http://", :subdomain => false)) if resource and resource.kind_of?(User)
    return root_url
  end

###
# System Hacks
###
  # This method replaces the default url_for in rails because they think that url_for(:subdomain => false) is ambiguous.
  def root_url_hack_helper(the_broken_url)
    return the_broken_url.sub('secure.', '')
    return stored_location_for(resource)
  end
end
