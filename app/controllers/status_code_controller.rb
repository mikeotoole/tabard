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

  # This is the forbidden method
  def forbidden
    render :fobidden, :status => :fobidden
  end

  # This is the 404 method
  def not_found
    render :not_found, :status => :not_found
  end
end