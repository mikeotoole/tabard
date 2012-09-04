###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for creating the active profile.
###
class StatusCodeController < ApplicationController
  skip_before_filter :block_unauthorized_user!
  skip_before_filter :limit_subdomain_access
  skip_before_filter :check_supported_browser

  # This is the forbidden method
  def forbidden
    render :fobidden, status: :fobidden
  end

  # This is the 404 method
  def not_found
    render :not_found, status: :not_found
  end

  # This method gets the Unsupported Browser page.
  def unsupported_browser
    # TODO - remove this after the beta test
    add_new_flash_message "We recommend using Chrome for the best Tabard experience.", "notice"
  end
end