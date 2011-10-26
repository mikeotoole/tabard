###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all announcement discussions for the current user.
###
class AnnouncementsController < ApplicationController
  respond_to :html
  
###
# REST Actions
###
  # GET /announcements/(.:format)
  def index
    @discussions = current_user.announcements
  end
end