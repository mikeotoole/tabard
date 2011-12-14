###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for activity stream.
###
class ActivitiesController < ApplicationController
  respond_to :html, :js

###
# Before Filters
###
  before_filter :block_unauthorized_user!, :except => [:index]

  ###
  # GET /activities
  # Possible params:
  # -> activity[:user_profile_id]
  # -> activity[:community_id]
  # -> updated[:since]
  # -> updated[:before]
  # -> max_items
  ###
  def index
    # params[:updated] = {:since => 2.day.ago, :before => 3.months.ago}
    # params[:updated] = {:before => 1.day.ago}
    params[:max_items] = 50

    @items = Activity.activities(params[:activity], params[:updated], params[:max_items])
  end
end
