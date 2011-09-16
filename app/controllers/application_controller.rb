###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
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

###
# Status Code Rescues
###
  # This method rescues from a CanCan Access Denied Exception
  rescue_from CanCan::AccessDenied do |exception|
    #redirect_to previous_page, :alert => exception.message
    http_status_code(:forbidden, exception)
  end

  # Returns a HTTP status code, with a nice error page
  def http_status_code(status, exception)
    # store the exception so its message can be used in the view
    @exception = exception
    flash[:alert] = @exception.message
    # Only add the error page to the status code if the reuqest-format was HTML
    respond_to do |format|
      format.html { render "home/index", :status => status }
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
# Public Methods
###
  ###
  # TODO Doug, Add the remaining of the message_class types.
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
  # _before_filter_
  #
  # This method remembers the current page in the session variable [:current_page]
  ###
  def remember_current_page
    session[:current_page] = request.path_info
  end

  ###
  # _after_filter_
  #
  # This method remembers the previous crumblin page in the session variable [:last_page]
  ###
  def remember_last_page
    session[:last_page] = session[:current_page] unless session[:current_page] == request.path_info
  end
end
