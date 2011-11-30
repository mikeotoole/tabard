###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is handling all announcement discussions for the current user.
###
class AnnouncementsController < ApplicationController
  before_filter :block_unauthorized_user!
  respond_to :html

###
# REST Actions
###
  # GET /announcements/(.:format)
  def index
    @hide_announcements = true
    @limit_read_amount = 10
  end

###
# Added Actions
###
  # PUT /announcements/batch_mark_as_seen/(.:format)
  def batch_mark_as_seen
    if params[:ids]
      params[:ids].each do |id|
        announcement = current_user.announcements.find_by_id(id[0])
        announcement.update_viewed(current_user.user_profile) if announcement
      end
    end
    redirect_to announcements_path
  end
end
