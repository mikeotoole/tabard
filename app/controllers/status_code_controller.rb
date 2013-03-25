###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for creating the active profile.
#
# Symbol meanings: http://www.codyfauser.com/2008/7/4/rails-http-status-code-to-symbol-mapping
###
class StatusCodeController < ApplicationController
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :limit_subdomain_access
  skip_before_filter :check_supported_browser

  # This is the forbidden method
  def forbidden
    render :forbidden, status: :forbidden
  end

  # This is the 404 method
  def not_found
    render :not_found, status: :not_found
  end

  def internal_server_error
    @request_id = !!request ? request.headers["HTTP_HEROKU_REQUEST_ID"] : nil
    @message = "I had a 500 error." + (@request_id ? " On the request with id #{@request_id}." : "")
    render :internal_server_error, status: :internal_server_error
  end

  # This method gets the Unsupported Browser page.
  def unsupported_browser
    flash.now[:notice] = "We recommend using Chrome for the best Tabard experience."
  end

  # This is for robots.
  def robots
    filename = Rails.env.production? ? "config/robots.production.txt" : "config/robots.staging.txt"
    robots = File.read(Rails.root + filename)
    render text: robots, layout: false, content_type: "text/plain"
  end

  # Used for blitz API
  def blitz
    render text: "42"
  end

  # Used for loaderio API
  def loaderio
    render text: "loaderio-5990c4bd3e6704d1a506c842975428c3"
  end

  def bang
    raise "Error Test"
  end
end
