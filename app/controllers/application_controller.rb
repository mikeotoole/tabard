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

  # This before_filter ensures that a profile is active.
  before_filter :ensure_active_profile_is_valid

  # This before_filter checks if user needs to be logged out.
  before_filter :check_force_logout

  # This before_filter checks if system is in maintenance mode.
  before_filter :check_maintenance_mode

  # This before_filter ensures that a user has accepted legal documents.
  before_filter :ensure_accepted_most_recent_legal_documents

  # This before_filter ensures that ssl mode is not running
  prepend_before_filter :ensure_not_ssl_mode

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
        format.html { render "status_code/forbidden", :status => status }
      else
        format.html { render "status_code/index", :status => status }
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
  # Used to check for maintenance mode.
  # [Returns] true if maintenance mode is on, false otherwise.
  ###
  def maintenance_mode?
    $maintenance_mode ||= false
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
  # This helper method lets the applicaiton layout view know whether or not to display the pitch partial.
  def show_pitch?
    !!@show_pitch
  end
  helper_method :show_pitch?

  # This helper method lets the applicaiton layout view know whether or not to hide announcements within the flash messages partial.
  def hide_announcements?
    !!@hide_announcements
  end
  helper_method :hide_announcements?

  ###
  # This helper method returns the current community that is in scope.
  # It is defined as nil when not in a subdomain.
  ###
  def current_community
    nil
  end
  helper_method :current_community

  ###
  # This helper method returns the current game that is in scope.
  # It is defined as nil when not in a game scope.
  ###
  def current_game
    nil
  end
  helper_method :current_game

###
# Active Character/Profile
###
  # Predicate helper method to test for an active profile.
  def profile_active?
    session[:profile_type] =~ /UserProfile/ || character_active?
  end
  helper_method :profile_active?

  # Helper method to check for active character.
  def character_active?
    session[:profile_type] =~ /Character$/
  end
  helper_method :character_active?

  # This helper method returns the currently active character or nil if there isn't one.
  def current_character
    return unless character_active?
    if defined? session[:profile_type].constantize
      session[:profile_type].constantize.find_by_id(session[:profile_id])
    end
  end
  helper_method :current_character

  # This helper method eturns the currently active user profile or nil if there isn't one.
  def current_profile
    return nil unless profile_active?
    if defined? session[:profile_type].constantize
      session[:profile_type].constantize.find_by_id(session[:profile_id])
    end
  end
  helper_method :current_profile

  # This helper method returns an Array with the users profile and characters info.
  def profiles
    if user_signed_in?
      profile_collection = current_user.active_profile_helper_collection(self.current_community, self.current_game)
      profiles = Array.new
      profile_collection.each do |profile|
        profiles << { :name => profile.name, :is_current => (profile == current_profile), :profile_id => profile.id, :type => profile.class }
      end
      profiles
    end
  end
  helper_method :profiles

  # This method activates a profile, given a profile_id and profile_type.
  def activate_profile(profile_id, profile_type)
    session[:profile_id] = profile_id
    session[:profile_type] = profile_type
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
    the_subdomain = request.subdomain
    the_protocol = request.protocol

    the_subdomain = "secure" if not(request.subdomain.present?) or request.subdomain != "secure"
    the_protocol = "https://" if !Rails.env.development? and request.protocol != "https://"

    redirect_to [the_protocol, (the_subdomain.blank? ? "" : "#{the_subdomain}."), request.domain, request.port_string, request.path].join if the_protocol != request.protocol or the_subdomain != request.subdomain # Try to downgrade gracefully...
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
  # This method ensures that a profile is active, or it will default to the user_profile
  ###
  def ensure_active_profile_is_valid
    if user_signed_in?
      unless current_profile
        activate_profile(current_user.user_profile_id, "UserProfile")
      end
      if current_profile != current_user.user_profile and not character_active?
        activate_profile(current_user.user_profile_id, "UserProfile")
      end
      if character_active? and not current_user.available_character_proxies(current_community,current_game).include?(current_character.character_proxy)
        default_character_proxy = nil
        default_character_proxy = current_user.default_character_proxy_for_a_game(current_game) if current_game
        if current_user.available_character_proxies(current_community,current_game).include?(default_character_proxy)
          activate_profile(default_character_proxy.character_id, default_character_proxy.character_class.to_s)
        else
          activate_profile(current_user.user_profile_id, "UserProfile")
        end
      end
    end
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
    if maintenance_mode?
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
# Devise
###
  # This method overrides the default devise method to set the proper protocol and subdomain
  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
    when :user, User
      store_location = session[:return_to]
      session[:return_to] = nil
      (store_location.nil?) ? root_url_hack_helper(root_url(:protocol => "http://", :subdomain => false)) : store_location.to_s
    else
      super
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
