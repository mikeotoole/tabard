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
  before_filter :authenticate_user!

  # This before_filter will prevent the actions from taking place in a subdomain.
  before_filter :limit_subdomain_access

  # This after_filter attempts to remember the current crumblin page.
  after_filter :remember_current_page

  # This before_filter attempts to remember the last crumblin page.
  before_filter :remember_last_page

  # This before_filter builds a list of the Crumblin supported games.
  before_filter :fetch_crumblin_games

  # This before_filter ensures that a profile is active.
  before_filter :ensure_active_profile_is_valid

  # This before_filter ensures that a user has accepted legal documents.
  before_filter :ensure_accepted_most_recent_legal_documents

###
# Status Code Rescues
###
  # This method rescues from a CanCan Access Denied Exception
  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to previous_page, :alert => exception.message
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
  # This method gets the users path to last page, if it is from this site, otherwise it returns the root path.
  def previous_page
    session[:last_page] ? session[:last_page] : root_url
  end

  ###
  # TODO Doug, Add the remaining of the message_class types. -MO
  # Adds a new message to the flash messsages array
  # [Args]
  #   * +message_body+ -> The body of the message.
  #   * +message_class+ -> What type of message it is. This can be "alert", "notice", ...
  #   * +message_title+ -> The title of the message.
  ###
  def add_new_flash_message(message_body, message_class="notice", message_title="")
    flash[:messages] = Array.new unless flash[:messages]
    flash[:messages] << { :class => message_class, :title => message_title, :body => message_body }
  end

###
# Protected Methods
###
protected

  # Builds a list of the Crumblin supported games.
  def fetch_crumblin_games
    @active_games = Game.all
  end

  # This Method is a helper that exposes the active_games
  def active_games
    @active_games
  end
  helper_method :active_games

  ###
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
# Active Character/Profile
###
  # Predicate method to test for an active profile.
  def profile_active?
    session[:profile_type] =~ /UserProfile/ || character_active?
  end
  helper_method :profile_active?

  # Method to check for active character.
  def character_active?
    session[:profile_type] =~ /Character$/
  end
  helper_method :character_active?

  # Returns the currently active character or nil if there isn't one.
  def current_character
    return unless character_active?
    if defined? session[:profile_type].constantize
      @current_profile ||= session[:profile_type].constantize.find_by_id(session[:profile_id])
    end
  end
  helper_method :current_character

  # Returns the currently active user profile or nil if there isn't one.
  def current_profile
    return nil unless profile_active?
    if defined? session[:profile_type].constantize
      @current_profile ||= session[:profile_type].constantize.find_by_id(session[:profile_id])
    end
  end
  helper_method :current_profile

  # Returns an Array with the users profile and characters info.
  def profiles
    if signed_in?
      profile_collection = current_user.active_profile_helper_collection(self.current_community, self.current_game)
      profiles = Array.new
      profile_collection.each do |profile|
        profiles << { :name => profile.name, :is_current => (profile == @current_profile), :profile_id => profile.id, :type => profile.class }
      end
      profiles
    end
  end
  helper_method :profiles

  # This method returns the current community that is in scope.
  def current_community
    nil
  end
  helper_method :current_community

  # This method returns the current game that is in scope.
  def current_game
    nil
  end
  helper_method :current_game

  # This method activates a profile, given a profile_id and profile_type.
  def activate_profile(profile_id, profile_type)
    session[:profile_id] = profile_id
    session[:profile_type] = profile_type
    @current_profile = session[:profile_type].constantize.find_by_id(session[:profile_id])
  end

###
# Callback Methods
###
  ###
  # _before_filter_
  #
  # This method remembers the current page in the session variable [:current_page]
  ###
  def remember_current_page
    session[:current_page] = request.url
  end

  ###
  # _after_filter_
  #
  # This method remembers the previous crumblin page in the session variable [:last_page]
  ###
  def remember_last_page
    session[:last_page] = session[:current_page] unless session[:current_page] == request.url
  end

  ###
  # _before_filter_
  #
  # This method ensures that a profile is active, or it will default to the user_profile
  ###
  def ensure_active_profile_is_valid
    if signed_in?
      unless current_profile
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
  # This method ensures that a profile is active, or it will default to the user_profile
  ###
  def ensure_accepted_most_recent_legal_documents
    if signed_in?
      if not current_user.accepted_current_terms_of_service 
        http_status_code(:locked)
      elsif not current_user.accepted_current_privacy_policy
        http_status_code(:locked)
      end
    end
  end
end
