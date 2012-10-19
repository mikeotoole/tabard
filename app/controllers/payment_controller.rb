###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This class is responsible for payment
###
class PaymentController < ApplicationController
  before_filter :turn_off

  def turn_off
    unless ENV["ENABLE_PAYMENT"]
      raise ActionController::RoutingError
    end
  end
end
