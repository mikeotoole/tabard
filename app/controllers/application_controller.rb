###
# Author::    DigitalAugment Inc. (mailto:code@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Don't Steal Me Bro!
#
# This is the application cotroller.
###
class ApplicationController < ActionController::Base
  protect_from_forgery

###
# Before Filters
###
  before_filter :authenticate_user!, :limit_subdomain_access

###
# Protected Methods
###
protected

  def limit_subdomain_access
    if request.subdomain.present?
      # TODO this error handling could be more sophisticated!
      redirect_to root_url(:subdomain => false)
    end
  end
end
