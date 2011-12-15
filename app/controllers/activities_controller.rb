###
# Author::    DigitalAugment Inc. (mailto:info@digitalaugment.com)
# Copyright:: Copyright (c) 2011 DigitalAugment Inc.
# License::   Proprietary Closed Source
#
# This controller is for activity stream.
###
class ActivitiesController < ApplicationController
  layout nil

###
# Before Filters
###
  before_filter :block_unauthorized_user!, :except => [:index]
  skip_before_filter :limit_subdomain_access

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
    if @items = Activity.activities(params[:activity], params[:updated], params[:max_items])
      render :partial => 'activities', :locals => { :activities => @items }
    else
      render :text => '', :layout => false
    end
  end
end
