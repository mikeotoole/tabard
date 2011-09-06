###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the application cotroller.
###
class ApplicationController < ActionController::Base
###
# Includes
###
  include UrlHelper

  # Turn on request forgery protection. Bear in mind that only non-GET, HTML/JavaScript requests are checked.
  protect_from_forgery

###
# Callbacks
###
  before_filter :authenticate_user!, :limit_subdomain_access

###
# Protected Methods
###
protected

  ###
  # TODO Joe, add description
  ###
  def limit_subdomain_access
    if request.subdomain.present?
      # OPTIMIZE this error handling could be more sophisticated!
      redirect_to root_url(:subdomain => false), :alert => "Invalid action on a subdomain."
    end
  end
end
